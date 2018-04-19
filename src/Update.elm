module Update exposing (update)

import Model exposing (Model, Flags, initialModel, Mode(..))
import Msg exposing (..)
import User.Update
import Document.ActionRead
import Document.Update
import Document.Cmd
import OutsideInfo
import User.Action
import Model exposing (Page(..), DocumentMenuState(..), SearchMenuState(..), MenuStatus(..))
import Utility


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

        GotoEditorPage ->
            ( { model | page = EditorPage }, Cmd.none )

        GotoReaderPage ->
            ( { model | page = ReaderPage }, Cmd.none )

        GotoStartPage ->
            ( { model | page = StartPage }, Cmd.none )

        ToggleSearchMenu menu ->
            let
                searchMenuState =
                    case menu of
                        SearchMenu MenuInactive ->
                            SearchMenu MenuActive

                        SearchMenu MenuActive ->
                            SearchMenu MenuInactive
            in
                ( { model | searchMenuState = searchMenuState }, Cmd.none )

        ToggleDocumentMenu menu ->
            let
                documentMenuState =
                    case menu of
                        DocumentMenu MenuInactive ->
                            DocumentMenu MenuActive

                        DocumentMenu MenuActive ->
                            DocumentMenu MenuInactive
            in
                ( { model | documentMenuState = documentMenuState }, Cmd.none )

        ChooseSearchType searchDomain ->
            ( { model | searchDomain = searchDomain, searchMenuState = SearchMenu MenuInactive, page = Utility.setPage model }
            , Document.Cmd.search model
            )

        CloseMenus ->
            ( { model | searchMenuState = SearchMenu MenuInactive, documentMenuState = DocumentMenu MenuInactive }, Cmd.none )

        Test ->
            ( { model
                | masterDocLoaded = True
                , masterDocumentId = model.currentDocument.parentId
                , masterDocumentTitle = model.currentDocument.parentTitle
              }
            , Document.Cmd.selectMaster model.currentDocument model
            )
