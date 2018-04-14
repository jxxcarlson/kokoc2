module Document.Update exposing (..)

import Model exposing (Model)
import Msg exposing (Msg)
import Document.Msg exposing (..)
import Document.ActionRead as ActionRead
import Document.Cmd
import Api.Error as Error


update : DocumentMsg -> Model -> ( Model, Cmd Msg )
update submessage model =
    case submessage of
        GetDocumentList result ->
            ActionRead.getDocuments result model

        LoadContent (Ok documentRecord) ->
            ActionRead.loadContent model documentRecord

        -- ( model, Cmd.none )
        LoadContent (Err error) ->
            let
                _ =
                    Debug.log "LoadContent" "error"
            in
                ( { model | message = "LC: " ++ Error.httpErrorString error }, Cmd.none )

        LoadContentAndRender (Ok documentRecord) ->
            let
                _ =
                    Debug.log "LoadContentAndRender" "OK"
            in
                ActionRead.loadContentAndRender model documentRecord

        -- ( model, Cmd.none )
        LoadContentAndRender (Err error) ->
            ( { model | message = "LCAR:" ++ Error.httpErrorString error }, Cmd.none )

        SelectDocument document ->
            ( { model | currentDocument = document }, Document.Cmd.putTextToRender document )
