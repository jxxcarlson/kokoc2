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
            ( ActionRead.loadContent model documentRecord, Cmd.none )

        LoadContent (Err error) ->
            ( { model | message = "LC: " ++ Error.httpErrorString error }, Cmd.none )

        LoadContentAndRender (Ok documentRecord) ->
            ( ActionRead.loadContent model documentRecord, Document.Cmd.putTextToRender documentRecord.document )

        LoadContentAndRender (Err error) ->
            ( { model | message = "LCAR:" ++ Error.httpErrorString error }, Cmd.none )

        SelectDocument document ->
            ( { model | currentDocument = document }, Document.Cmd.putTextToRender document )
