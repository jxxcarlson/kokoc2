module Update exposing (update)

import Model exposing (Model, Flags, initialModel, Mode(..))
import Msg exposing (..)
import User.Update
import Document.ActionRead
import Document.Update
import Document.Cmd
import Document.Model exposing (DocType(..), DocumentAccessibility)
import OutsideInfo
import User.Action
import Model
    exposing
        ( Page(..)
        , DocumentMenuState(..)
        , SearchMenuState(..)
        , MenuStatus(..)
        , NewDocumentPanelState(..)
        , DeleteDocumentState(..)
        , DocumentAttributePanelState(..)
        )
import Utility
import Configuration
import Nav.Navigation
import View.MenuManager


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
                    let
                        document =
                            model.currentDocument

                        updatedDocument =
                            { document | renderedContent = renderedText }
                    in
                        ( { model | currentDocument = updatedDocument }, Cmd.none )

        LogErr error ->
            ( { model | errorMessage = "Error: " ++ error }, Cmd.none )

        GotoEditorPage ->
            ( { model | page = EditorPage }, Cmd.none )

        GotoReaderPage ->
            ( { model | page = ReaderPage }, Cmd.none )

        GotoStartPage ->
            ( { model | page = StartPage }, Document.Cmd.getDocuments "" "/public/documents" "id=181" (DocumentMsg << GetDocumentList) )

        ToggleSearchMenu menu ->
            View.MenuManager.toggleSearchMenu model menu

        ToggleDocumentMenu menu ->
            View.MenuManager.toggleDocumentsMenu model menu

        ToggleVersionsMenu menu ->
            View.MenuManager.toggleVersionsMenu model menu

        CloseMenus ->
            View.MenuManager.closeMenus model

        DisplayNewDocumentPanel ->
            View.MenuManager.displayNewDocumentsPanel model

        DisplayDocumentAttributesPanel ->
            View.MenuManager.displayNewDocumentsPanel model

        CancelNewDocument ->
            View.MenuManager.cancelNewDocument model

        ChooseSearchType searchDomain ->
            ( { model | searchDomain = searchDomain, searchMenuState = SearchMenu MenuInactive, page = Utility.setPage model }
            , Document.Cmd.search model
            )

        InputNewDocumentTitle str ->
            ( { model | newDocumentTitle = str }, Cmd.none )

        SetDocumentTextType textType ->
            ( { model | documentTextType = textType }, Cmd.none )

        SetDocumentType docType ->
            ( { model | documentType = docType }, Cmd.none )

        SetSubdocumentPosition subdocumentPosition ->
            ( { model | subdocumentPosition = subdocumentPosition }, Cmd.none )

        InputRepositoryName str ->
            ( { model | repositoryName = str }, Cmd.none )

        InputShareDocumentCommand str ->
            ( { model | shareDocumentCommand = str }, Cmd.none )

        GotoHomePage ->
            ( { model | page = ReaderPage }, Document.Cmd.searchWithQueryCmd model Document.Model.PublicDocument <| "key=home&authorname=" ++ (Utility.getUsername model) )

        GoToPage maybepage ->
            -- Navigation.newUrl (Configuration.client ++ "/##public/181")
            Nav.Navigation.navigateTo maybepage model

        Test ->
            ( model
            , Document.Cmd.loadDocumentIntoDictionary (Utility.getToken model) 181
            )
