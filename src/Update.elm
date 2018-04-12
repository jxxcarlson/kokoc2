module Update exposing (update)

import Model exposing (Model, Flags, initialModel, Mode(..))
import Msg exposing (..)
import User.Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOpz ->
            ( model, Cmd.none )

        UserMsg submessage ->
            User.Update.update submessage model
