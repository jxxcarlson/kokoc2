module Document.Update exposing (..)

import Model exposing (Model, Page(..))
import Msg exposing (Msg)
import Document.Msg exposing (..)
import Document.ActionRead as ActionRead
import Document.Cmd
import Document.Master
import Api.Error as Error
import Utility


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

            SelectDocument document ->
                let
                    cmd =
                        if document.attributes.docType == "master" then
                            Document.Master.select document model
                        else
                            Document.Cmd.putTextToRender document
                in
                    ( { model | currentDocument = document }, cmd )

            InputSearchQuery str ->
                ( { model | searchQuery = str }, Cmd.none )

            SearchOnKey keyCode ->
                if keyCode == 13 then
                    ( { model | page = Utility.setPage model }, Document.Cmd.search model )
                else
                    ( model, Cmd.none )



{- HELPERS -}
