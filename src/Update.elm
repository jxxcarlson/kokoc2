module Update exposing (update)

import Model exposing (Model, Flags, initialModel, Mode(..) )
import Msg exposing (..)
import User.Update
import Document.Update
import User.Action
import Model exposing(Page(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOpz ->
            ( model, Cmd.none )

        UserMsg submessage ->
            User.Update.update submessage model

        DocumentMsg submessage ->
            Document.Update.update submessage model

        Outside infoForElm ->
            case infoForElm of
                UserLoginInfo userLoginRecord ->
                    ( User.Action.reconnectUser model userLoginRecord, Cmd.none )

        LogErr error ->
            ( { model | message = "Error: " ++ error }, Cmd.none )

        GotoReaderPage ->
            ( { model | page = ReaderPage }, Cmd.none )

        GotoStartPage ->
            ( { model | page = StartPage }, Cmd.none )
