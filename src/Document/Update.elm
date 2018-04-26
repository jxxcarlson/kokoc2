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
import Msg exposing (Msg)
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

            LoadIntoDictionary (Ok documentRecord) ->
                let
                    _ =
                        Debug.log "LoadIntoDictionary" "Ok!!"

                    _ =
                        Debug.log "FOO"

                    _ =
                        Debug.log "load, dict, doc id" documentRecord.document.id

                    documentDict =
                        model.documentDict

                    updatedDict =
                        Debug.log "updatedDict"
                            (Dictionary.set "startDocument" documentRecord.document documentDict)
                in
                    ( { model | documentDict = updatedDict }, Cmd.none )

            LoadIntoDictionary (Err error) ->
                let
                    _ =
                        Debug.log "LoadIntoDictionary" "Error"
                in
                    ( { model | message = "LoadIntoDictionary:" ++ Error.httpErrorString error }, Cmd.none )

            SaveDocument (Ok documentRecord) ->
                ( { model | message = "Document saved: " ++ documentRecord.document.title }, Cmd.none )

            SaveDocument (Err error) ->
                ( { model | message = "Save: " ++ Error.httpErrorString error }, Cmd.none )

            LoadParent currentDocument ->
                ActionRead.loadParentDocument model currentDocument

            NewDocument ->
                ActionEdit.newDocument model

            CreateDocument (Ok documentRecord) ->
                ActionEdit.selectNewDocument model documentRecord.document

            CreateDocument (Err error) ->
                ( { model | message = "CD: " ++ Error.httpErrorString error }, Cmd.none )

            DeleteDocument (Ok str) ->
                ( ActionEdit.deleteDocumentFromList model.currentDocument model, Cmd.none )

            DeleteDocument (Err error) ->
                ( { model | message = "CD: " ++ Error.httpErrorString error }, Cmd.none )

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
                in
                    ( { model | currentDocument = updatedDocument }, Cmd.none )

            RenderContent ->
                if model.currentDocument.attributes.textType == MiniLatex then
                    ActionEdit.renderLatex model
                else
                    ( model, Document.Cmd.renderNonLatexCmd model )

            PrepareToDeleteDocument ->
                ( { model | deleteDocumentState = DeleteDocumentPending }, Cmd.none )

            DoDeleteDocument ->
                ActionEdit.deleteDocument model

            UpdateDocumentAttributes ->
                ActionEdit.updateAttributesOfCurrentDocument model

            GetRandomDocuments ->
                ( { model
                    | page = ReaderPage
                    , searchMenuState = SearchMenu MenuInactive
                    , maybeMasterDocument = Nothing
                  }
                , Document.Cmd.randomDocuments model
                )

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
                ( { model | message = "Error setting key in documentDict" }, Cmd.none )

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



{- 12 ACTIONS -}
-- s( { model | message = "Render content" }, Document.Cmd.putTextToRender model.currentDocument )
{- HELPERS -}
