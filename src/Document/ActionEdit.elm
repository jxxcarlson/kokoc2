module Document.ActionEdit
    exposing
        ( createDocument
        , selectNewDocument
        , deleteDocument
        , deleteDocumentFromList
        , newDocument
        , updateDocument
        , updateAttributesOfCurrentDocument
        , togglePublic
        , updateRepositoryName
        , renderContent
        , renderContentAndSave
        )

{-| The Document.ActionEdit module is composed of functions
with return value (Model, Cmd Msg) and their helpers. The
exported functions are consumed by the update function in
Document.Update. Functions in this module are used for creating,
editing and deleting documents. 19 functions total, 11 exported.
-}

import Http
import Task exposing (Task)
import Regex
import Time
import Dict exposing (Dict)


--

import Configuration
import Model
    exposing
        ( Model
        , Page(EditorPage)
        , DocumentMenuState(..)
        , MenuStatus(..)
        , NewDocumentPanelState(..)
        , DeleteDocumentState(..)
        , DocumentAttributePanelState(..)
        , SubdocumentPosition(..)
        )
import Msg exposing (Msg(DocumentMsg, ReceiveStartTime))
import OutsideInfo exposing (InfoForOutside(PutTextToRender))


--

import Document.Default
import Document.Model exposing (Document, DocumentAttributes, DocumentRecord, DocumentListRecord, DocType(..), TextType(..))
import Document.Data as Data
import Document.Cmd
import Document.Msg exposing (DocumentMsg(GetDocumentList, SaveDocument))
import Document.QueryParser as QueryParser
import Document.Query as Query
import Document.Task
import Document.Dictionary as Dictionary
import Document.MeenyLatex
import Document.Utility
import MeenyLatex.Source
import MeenyLatex.RenderLatexForExport
import MeenyLatex.Driver
import Utility
import Utility.KeyValue as KeyValue


createDocument : Model -> Document -> ( Model, Cmd Msg )
createDocument model document =
    ( { model
        | page = EditorPage
        , documentMenuState = DocumentMenu MenuInactive
        , newDocumentPanelState = NewDocumentPanelInactive
        , currentDocument = document
        , maybePreviousDocument = Just model.currentDocument
      }
    , Document.Cmd.createDocumentCmd document (Utility.getToken model)
    )


selectNewDocument : Model -> Document -> ( Model, Cmd Msg )
selectNewDocument model document =
    let
        _ =
            Debug.log "selectNewDocument, parentId" document.parentId

        previousDocumentId =
            case model.maybePreviousDocument of
                Nothing ->
                    0

                Just document ->
                    document.id

        token =
            Utility.getToken model

        attachChildTask =
            Document.Task.attachChildToMasterDocumentTask model token document.id previousDocumentId

        selectMasterTask =
            Document.Task.selectMasterTask document.parentId (Utility.getToken model)

        attachAndSelectMasterTask =
            attachChildTask |> Task.andThen (\_ -> selectMasterTask)

        commands =
            if document.parentId > 0 then
                [ Document.Cmd.putTextToRender document
                , Task.attempt (Msg.DocumentMsg << GetDocumentList) attachAndSelectMasterTask
                ]
            else
                [ Document.Cmd.putTextToRender document ]
    in
        ( { model
            | currentDocument = document
            , documentList = [ document ] ++ model.documentList
            , counter = model.counter + 1
          }
        , Cmd.batch commands
        )



-- |> Task.andThen (Msg.DocumentMsg << GetDocumentList) (Document.Task.selectMasterTask document.parentId (Utility.getToken model))


renderContent : Model -> ( Model, Cmd Msg )
renderContent model =
    if model.currentDocument.attributes.textType == MeenyLatex then
        renderLatex model
    else
        ( model, Document.Cmd.renderNonLatexCmd model )


renderContentAndSave : Model -> ( Model, Cmd Msg )
renderContentAndSave model =
    if model.currentDocument.attributes.textType == MeenyLatex then
        renderLatex model
    else
        ( { model | currentDocumentNeedsToBeSaved = False }
        , Cmd.batch
            [ Document.Cmd.renderNonLatexCmd model
            , Document.Cmd.saveDocumentCmd model.currentDocument (Utility.getToken model)
            , Task.perform ReceiveStartTime Time.now
            ]
        )



{- renderLatex and helpers -}


renderLatex : Model -> ( Model, Cmd Msg )
renderLatex model =
    let
        document =
            model.currentDocument

        contentToRender =
            getEnrichedContent document

        newEditRecord =
            MeenyLatex.Driver.update 666 model.editRecord contentToRender

        macroDefinitions =
            Document.MeenyLatex.getMacroDefinitions model

        textToExport =
            [ MeenyLatex.Source.texPrefix
            , macroDefinitions
            , sectionNumberCommand -1 document
            , tableOfContentsMacro document
            , MeenyLatex.RenderLatexForExport.renderLatexForExport document.content
            , MeenyLatex.Source.texSuffix
            ]
                |> String.join ""

        renderedContent =
            (MeenyLatex.Driver.getRenderedText macroDefinitions newEditRecord)

        updatedDocument =
            { document | renderedContent = renderedContent }
    in
        ( { model
            | currentDocument = updatedDocument
            , editRecord = newEditRecord
            , textToExport = textToExport
            , currentDocumentNeedsToBeSaved = False
          }
        , Cmd.batch
            [ Document.Cmd.putTextToRender updatedDocument
            , Document.Cmd.saveDocumentCmd updatedDocument (Utility.getToken model)
            , Task.perform ReceiveStartTime Time.now
            ]
        )


getEnrichedContent : Document -> String
getEnrichedContent document =
    let
        maybeSectionNumber =
            KeyValue.getIntValueForKeyFromTagList "sectionNumber" document.tags

        sectionNumberCommand_ =
            sectionNumberCommand 0 document

        tableOfContentsMacro_ =
            (tableOfContentsMacro document)
    in
        sectionNumberCommand_ ++ tableOfContentsMacro_ ++ document.content


sectionNumberCommand : Int -> Document -> String
sectionNumberCommand shift document =
    let
        maybeSectionNumber =
            KeyValue.getIntValueForKeyFromTagList "sectionNumber" document.tags
    in
        case maybeSectionNumber of
            Just id ->
                "\\setcounter{section}{" ++ toString (id + shift) ++ "}"

            Nothing ->
                ""


tableOfContentsMacro : Document -> String
tableOfContentsMacro document =
    let
        maybeTOCSwitch =
            KeyValue.getStringValueForKeyFromTagList "toc" document.tags
    in
        case maybeTOCSwitch of
            Just "yes" ->
                "\n\n\\tableofcontents\n\n"

            Just _ ->
                "\n\n"

            Nothing ->
                "\n\n"



{- End of renderLatex and helpers -}


deleteDocumentFromList : Document -> Model -> Model
deleteDocumentFromList document model =
    let
        documentList =
            model.documentList

        updatedDocumentList =
            Utility.removeWhen (\doc -> doc.id == model.currentDocument.id) documentList

        newCurrentDocument =
            List.head updatedDocumentList |> Maybe.withDefault (Document.Default.make "Error" "There was an error deleting this documents.")
    in
        { model
            | documentList = updatedDocumentList
            , currentDocument = newCurrentDocument
        }


deleteDocument : Model -> ( Model, Cmd Msg )
deleteDocument model =
    let
        documentToDelete =
            model.currentDocument

        token =
            Utility.getToken model

        newModel =
            deleteDocumentFromList model.currentDocument model
    in
        ( { newModel
            | deleteDocumentState = DeleteDocumentInactive
            , documentMenuState = DocumentMenu MenuInactive
          }
        , Document.Cmd.deleteDocument token documentToDelete.id
        )


newDocument : Model -> ( Model, Cmd Msg )
newDocument model =
    let
        newDocument =
            makeNewDocument model |> putParent model |> putAuthorInfo model

        amendedAttributes =
            newDocument.attributes |> putTextAndDocumentType model

        amendedNewDocument =
            { newDocument | attributes = amendedAttributes }
    in
        createDocument model amendedNewDocument



{- New document helpers -}


makeNewDocument : Model -> Document
makeNewDocument model =
    let
        title =
            if model.newDocumentTitle /= "" then
                model.newDocumentTitle
            else
                "New Document"
    in
        case model.documentType of
            Standard ->
                Document.Default.make title "Write something here ... "

            Master ->
                Document.Default.make title Document.Default.masterDocText


putAuthorInfo : Model -> Document -> Document
putAuthorInfo model document =
    case model.maybeCurrentUser of
        Nothing ->
            document

        Just currentUser ->
            { document | authorId = currentUser.id, authorName = currentUser.username }


putParent : Model -> Document -> Document
putParent model document =
    case model.maybeMasterDocument of
        Just masterDocument ->
            if model.subdocumentPosition /= DoNotAttachSubdocument then
                { document | parentId = masterDocument.id, parentTitle = masterDocument.title }
            else
                document

        Nothing ->
            document


putTextAndDocumentType : Model -> DocumentAttributes -> DocumentAttributes
putTextAndDocumentType model documentAttributes =
    case model.documentType of
        Standard ->
            { documentAttributes | textType = model.documentTextType, docType = model.documentType }

        Master ->
            { documentAttributes | textType = Asciidoc, docType = model.documentType }



{- End new document helpers -}


togglePublic : Model -> ( Model, Cmd Msg )
togglePublic model =
    let
        currentDocument =
            model.currentDocument

        currentAttributes =
            currentDocument.attributes

        updatedAttributes =
            { currentAttributes | public = not currentAttributes.public }

        updatedDocument =
            { currentDocument | attributes = updatedAttributes }

        token =
            Utility.getToken model
    in
        ( { model | currentDocument = updatedDocument }, Document.Cmd.saveDocumentCmd updatedDocument token )


updateDocument : Model -> Document -> Cmd Msg
updateDocument model document =
    Document.Cmd.saveDocumentCmd document (Utility.getToken model)


updateAttributesOfCurrentDocument : Model -> ( Model, Cmd Msg )
updateAttributesOfCurrentDocument model =
    let
        document =
            model.currentDocument

        attributes =
            document.attributes

        updatedAttributes =
            { attributes | textType = model.documentTextType, docType = model.documentType }

        updatedDocument =
            { document | title = model.newDocumentTitle, attributes = updatedAttributes }
    in
        ( { model
            | currentDocument = updatedDocument
            , documentMenuState = DocumentMenu MenuInactive
            , documentAttributePanelState = DocumentAttributePanelInactive
            , documentList =
                Document.Utility.updateDocumentList updatedDocument model.documentList
          }
        , updateDocument model updatedDocument
        )


updateRepositoryName : Model -> ( Model, Cmd Msg )
updateRepositoryName model =
    let
        document =
            model.currentDocument

        attributes =
            document.attributes

        newAttributes =
            { attributes | archive = model.repositoryName }

        newDocument =
            { document | attributes = newAttributes }

        token =
            Utility.getToken model
    in
        ( { model | currentDocument = newDocument }, Document.Cmd.saveDocumentCmd newDocument token )
