module Document.Update exposing (update)

import Model
    exposing
        ( Model
        , Page(..)
        , DeleteDocumentState(..)
        , DocumentMenuState(..)
        , SearchMenuState(..)
        , MenuStatus(..)
        )
import Msg exposing (Msg(ReceiveTime))
import Document.Msg exposing (..)
import Document.ActionRead as ActionRead
import Document.Model exposing (Document, TextType(..), DocType(..))
import Document.Cmd
import Api.Error as Error
import Utility
import Document.ActionEdit as ActionEdit
import Task
import Document.Default
import Document.Dictionary as Dictionary
import Document.TOC
import Document.MasterDocument
import Time


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
                ( { model | errorMessage = "LC: " ++ Error.httpErrorString error }, Cmd.none )

            LoadContentAndRender (Ok documentRecord) ->
                ( ActionRead.loadContent model documentRecord, Document.Cmd.putTextToRender documentRecord.document )

            LoadContentAndRender (Err error) ->
                ( { model | errorMessage = "LCAR:" ++ Error.httpErrorString error }, Cmd.none )

            LoadIntoDictionary (Ok documentRecord) ->
                let
                    documentDict =
                        model.documentDict

                    updatedDict =
                        (Dictionary.set "startDocument" documentRecord.document documentDict)
                in
                    ( { model | documentDict = updatedDict }, Cmd.none )

            LoadIntoDictionary (Err error) ->
                ( { model | errorMessage = "LoadIntoDictionary:" ++ Error.httpErrorString error }, Cmd.none )

            SaveDocument (Ok documentRecord) ->
                ( { model | message = "Document saved" }, Task.perform ReceiveTime Time.now )

            SaveDocument (Err error) ->
                ( { model | errorMessage = "Save: " ++ Error.httpErrorString error }, Cmd.none )

            LoadParent currentDocument ->
                ActionRead.loadParentDocument model currentDocument

            NewDocument ->
                ActionEdit.newDocument model

            CreateDocument (Ok documentRecord) ->
                ActionEdit.selectNewDocument model documentRecord.document

            CreateDocument (Err error) ->
                ( { model | errorMessage = "CD: " ++ Error.httpErrorString error }, Cmd.none )

            DeleteDocument (Ok str) ->
                ( ActionEdit.deleteDocumentFromList model.currentDocument model, Cmd.none )

            DeleteDocument (Err error) ->
                ( { model | errorMessage = "CD: " ++ Error.httpErrorString error }, Cmd.none )

            SelectDocument document ->
                ActionRead.selectDocument model document

            InputSearchQuery str ->
                ( { model | searchQuery = str }, Cmd.none )

            SearchOnKey keyCode ->
                if keyCode == 13 then
                    ( { model
                        | page = Utility.setPage model
                        , maybeMasterDocument = Nothing
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

                    _ =
                        Debug.log "HOLA!"

                    n =
                        Debug.log "InputEditorText, chars" (String.length document.content)

                    cmd =
                        if document.attributes.textType == MiniLatex then
                            Cmd.none
                        else
                            Document.Cmd.putTextToRender updatedDocument
                in
                    ( { model | currentDocument = updatedDocument, currentDocumentNeedsToBeSaved = True }, cmd )

            RenderContent ->
                ActionEdit.renderContent model

            RenderContentAndSave ->
                ActionEdit.renderContentAndSave model

            PrepareToDeleteDocument ->
                ( { model | deleteDocumentState = DeleteDocumentPending }, Cmd.none )

            DoDeleteDocument ->
                ActionEdit.deleteDocument model

            UpdateDocumentAttributes ->
                ActionEdit.updateAttributesOfCurrentDocument model

            GetRandomDocuments ->
                ActionRead.getRandomDocuments model

            GetRecentDocuments ->
                ActionRead.getRecentDocuments model 7

            SetDocumentInDict (Ok ( documentsRecord, key )) ->
                let
                    emptyDocument =
                        Document.Default.make "Empty document" "No content"

                    document =
                        case List.head documentsRecord.documents of
                            Just document ->
                                document

                            Nothing ->
                                emptyDocument

                    documentDict =
                        model.documentDict

                    newDocumentDict =
                        if document /= emptyDocument then
                            Dictionary.set key document documentDict
                        else
                            documentDict
                in
                    ( { model | documentDict = newDocumentDict }, Cmd.none )

            SetDocumentInDict (Err err) ->
                ( { model | errorMessage = "Error setting key in documentDict" }, Cmd.none )

            RenumberMasterDocument ->
                Document.TOC.renumberMasterDocument model

            CompileMaster ->
                Document.MasterDocument.prepareExportLatexFromMaster model

            TogglePublic ->
                ActionEdit.togglePublic model

            SetRepositoryName ->
                ActionEdit.updateRepositoryName model

            UpdateShareData ->
                ( model, Document.Cmd.updateSharingData model )
