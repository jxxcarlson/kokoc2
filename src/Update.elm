module Update exposing (update)

import Model exposing (Model, Flags, initialModel, Mode(..))
import Msg exposing (..)
import User.Update
import Document.ActionRead
import Document.ActionEdit
import Document.Update
import Document.Cmd
import Document.Msg exposing (DocumentMsg(RenderContent))
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
import Keyboard.Extra exposing (Key(..))
import Dict
import View.DocumentMenu


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
            goToStartPage model

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
            goToHomePage model

        GoToPage maybepage ->
            -- Navigation.newUrl (Configuration.client ++ "/##public/181")
            Nav.Navigation.navigateTo maybepage model

        KeyboardMsg keyMsg ->
            let
                pressedKeys =
                    Keyboard.Extra.update keyMsg model.pressedKeys

                _ =
                    Debug.log "pressedKeys" pressedKeys
            in
                respondToKeysDispatch model pressedKeys

        -- respondToKeys model <| Keyboard.Extra.update keyMsg model.pressedKeys
        DisplayDocumentAttributesPanel ->
            ( { model | documentAttributePanelState = DocumentAttributePanelActive }, Cmd.none )

        Test ->
            ( model
            , Document.Cmd.loadDocumentIntoDictionary (Utility.getToken model) 181
            )


respondToKeysDispatch : Model -> List Key -> ( Model, Cmd Msg )
respondToKeysDispatch model pressedKeys =
    if model.previousKey == Control then
        respondToKeys model pressedKeys
    else
        ( { model | previousKey = headKey pressedKeys }, Cmd.none )


respondToKeys : Model -> List Key -> ( Model, Cmd Msg )
respondToKeys model pressedKeys =
    let
        newModel =
            { model | previousKey = headKey pressedKeys }
    in
        (lookupKeyAction <| headKey pressedKeys) newModel


lookupKeyAction : Key -> (Model -> ( Model, Cmd Msg ))
lookupKeyAction key =
    case key of
        BackSlash ->
            \model -> Document.ActionEdit.renderContent model

        CharA ->
            \model -> ( { model | documentAttributePanelState = DocumentAttributePanelActive }, Cmd.none )

        CharC ->
            \model -> View.MenuManager.closeMenus model

        CharE ->
            \model -> ( { model | page = EditorPage }, Cmd.none )

        CharH ->
            \model -> goToHomePage model

        CharN ->
            \model -> Document.ActionEdit.newDocument model

        CharR ->
            \model -> ( { model | page = ReaderPage }, Cmd.none )

        CharS ->
            \model -> goToStartPage model

        CharV ->
            \model -> View.MenuManager.toggleVersionsMenu model model.versionsMenuState

        CharX ->
            \model -> Document.ActionRead.getRandomDocuments model

        _ ->
            \model -> ( model, Cmd.none )


headKey : List Key -> Key
headKey keyList =
    List.head keyList |> Maybe.withDefault F24


goToStartPage : Model -> ( Model, Cmd Msg )
goToStartPage model =
    ( { model | page = StartPage }, Document.Cmd.getDocuments "" "/public/documents" "id=181" (DocumentMsg << GetDocumentList) )


goToHomePage : Model -> ( Model, Cmd Msg )
goToHomePage model =
    ( { model | page = ReaderPage }, Document.Cmd.searchWithQueryCmd model Document.Model.PublicDocument <| "key=home&authorname=" ++ (Utility.getUsername model) )
