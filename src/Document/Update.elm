module Document.Update exposing (update)

import Model exposing (Model, Page(..))
import Msg exposing (Msg)
import Document.Msg exposing (..)
import Document.ActionRead as ActionRead
import Document.Model exposing (Document)
import Document.Cmd
import Api.Error as Error
import Utility
import Document.ActionEdit as ActionEdit
import MiniLatex.Driver
import Task
import Document.Default


update : DocumentMsg -> Model -> ( Model, Cmd Msg )
update submessage model =
    let
        token =
            case model.maybeCurrentUser of
                Nothing ->
                    ""

                Just user ->
                    user.token
    in
        case submessage of
            GetDocumentList result ->
                ActionRead.getDocuments result model

            LoadContent (Ok documentRecord) ->
                ( ActionRead.loadContent model documentRecord, Cmd.none )

            LoadContent (Err error) ->
                ( { model | message = "LC: " ++ Error.httpErrorString error }, Cmd.none )

            LoadContentAndRender (Ok documentRecord) ->
                ( ActionRead.loadContent model documentRecord, Document.Cmd.putTextToRender documentRecord.document )

            LoadContentAndRender (Err error) ->
                ( { model | message = "LCAR:" ++ Error.httpErrorString error }, Cmd.none )

            SaveDocument (Ok documentRecord) ->
                ( model, Cmd.none )

            SaveDocument (Err error) ->
                ( { model | message = "Save: " ++ Error.httpErrorString error }, Cmd.none )

            LoadParent currentDocument ->
                ActionRead.loadParentDocument model currentDocument

            NewDocument ->
                ActionEdit.createDocument model (Document.Default.make "New Document (X)" "Write something here ... ")

            CreateDocument (Ok documentRecord) ->
                ActionEdit.selectNewDocument model documentRecord.document

            CreateDocument (Err error) ->
                ( { model | message = "CD: " ++ Error.httpErrorString error }, Cmd.none )

            SelectDocument document ->
                ( { model
                    | currentDocument = document
                    , masterDocLoaded = masterDocLoaded model document
                    , masterDocumentId = masterDocumentId model document
                    , masterDocumentTitle = masterDocumentTitle model document
                    , editRecord = MiniLatex.Driver.emptyEditRecord
                    , counter = model.counter + 1
                  }
                , Document.Cmd.selectMasterOrRender model document
                )

            InputSearchQuery str ->
                ( { model | searchQuery = str }, Cmd.none )

            SearchOnKey keyCode ->
                if keyCode == 13 then
                    ( { model
                        | page = Utility.setPage model
                        , masterDocLoaded = False
                        , masterDocumentId = 0
                        , masterDocumentTitle = ""
                      }
                    , Document.Cmd.search model
                    )
                else
                    ( { model | counter = model.counter + 1 }, Cmd.none )

            InputEditorText str ->
                let
                    document =
                        model.currentDocument

                    updatedDocument =
                        { document | content = str }
                in
                    ( { model | currentDocument = updatedDocument }, Cmd.none )

            RenderContent ->
                if model.currentDocument.attributes.textType == "latex" then
                    ActionEdit.renderLatex model
                else
                    ( model, Document.Cmd.renderNonLatexCmd model )



-- s( { model | message = "Render content" }, Document.Cmd.putTextToRender model.currentDocument )
{- HELPERS -}


masterDocLoaded : Model -> Document -> Bool
masterDocLoaded model document =
    if document.attributes.docType == "master" then
        True
    else if model.masterDocumentId > 0 && document.parentId == model.masterDocumentId then
        True
    else
        False


masterDocumentId : Model -> Document -> Int
masterDocumentId model document =
    if document.attributes.docType == "master" then
        document.id
    else if model.masterDocumentId > 0 && document.parentId == model.masterDocumentId then
        model.masterDocumentId
    else
        0


masterDocumentTitle : Model -> Document -> String
masterDocumentTitle model document =
    if document.attributes.docType == "master" then
        document.title
    else if model.masterDocumentId > 0 && document.parentId == model.masterDocumentId then
        model.masterDocumentTitle
    else
        ""
