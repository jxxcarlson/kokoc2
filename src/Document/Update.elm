module Document.Update exposing (update)

import Model
    exposing
        ( Model
        , Page(..)
        , DeleteDocumentState(..)
        , DocumentMenuState(..)
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
                -- let
                --     updatedDocument =
                --         documentRecord.document
                -- in
                -- ( { model | currentDocument = updatedDocument }, Cmd.none )
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
                if model.currentDocument.attributes.textType == MiniLatex then
                    ActionEdit.renderLatex model
                else
                    ( model, Document.Cmd.renderNonLatexCmd model )

            PrepareToDeleteDocument ->
                ( { model | deleteDocumentState = DeleteDocumentPending }, Cmd.none )

            DoDeleteDocument ->
                ActionEdit.deleteDocument model



{- 12 ACTIONS -}
-- s( { model | message = "Render content" }, Document.Cmd.putTextToRender model.currentDocument )
{- HELPERS -}
