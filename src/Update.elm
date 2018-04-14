module Update exposing (update)

import Model exposing (Model, Flags, initialModel, Mode(..))
import Msg exposing (..)
import User.Update
import Document.ActionRead
import Document.Update
import Document.Cmd
import OutsideInfo
import User.Action
import Model exposing (Page(..))


--- TEST:

import Document.Msg exposing (DocumentMsg(GetDocumentList, LoadContentAndRender))


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

                RenderedText renderedText ->
                    OutsideInfo.updateRenderedText model renderedText

        LogErr error ->
            ( { model | message = "Error: " ++ error }, Cmd.none )

        GotoReaderPage ->
            ( { model | page = ReaderPage }, Cmd.none )

        GotoStartPage ->
            ( { model | page = StartPage }, Cmd.none )

        Test ->
            let
                cmd =
                    case model.maybeCurrentUser of
                        Just user ->
                            Document.Cmd.getDocuments user.token "/documents" "random&loading" (DocumentMsg << GetDocumentList)

                        ---Document.Cmd.getOneDocument user.token "/documents/109" "" (DocumentMsg << LoadContentAndRender)
                        Nothing ->
                            Cmd.none
            in
                ( model, cmd )
