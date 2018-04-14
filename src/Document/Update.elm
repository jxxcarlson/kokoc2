module Document.Update exposing (..)

import Model exposing (Model)
import Msg exposing (Msg)
import Document.Msg exposing (..)
import Document.Action as Action


update : DocumentMsg -> Model -> ( Model, Cmd Msg )
update submessage model =
    case submessage of
        GetDocumentList result ->
            Action.getDocuments result model
        SelectDocument document -> 
           (model, Cmd.none)
