module Document.Update exposing (..)

import Model exposing (Model)
import Msg exposing (Msg)
import Document.Msg exposing (..)
import Api.Request as Request
import Document.RequestParameters as RequestParameters
import Document.Action as Action


update : DocumentMsg -> Model -> ( Model, Cmd Msg )
update submessage model =
    case submessage of
        GetDocumentList result ->
            Action.getDocuments result model
