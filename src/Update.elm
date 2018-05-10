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
import Time
import Task
import Document.Utility
import User.Action


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
            processInfoForElm model infoForElm

        LogErr error ->
            ( { model | errorMessage = "Error: " ++ error }, Cmd.none )

        GotoEditorPage ->
            goToEditorPage model

        GotoReaderPage ->
            goToReaderPage model

        GotoStartPage ->
            goToStartPage model

        GotoAdminPage ->
            ( { model | page = AdminPage }, User.Action.getUserListCommmand )

        ToggleSearchMenu menu ->
            View.MenuManager.toggleSearchMenu model menu

        ToggleDocumentMenu menu ->
            View.MenuManager.toggleDocumentsMenu model menu

        ToggleTagsMenu menu ->
            View.MenuManager.toggleTagsMenu model menu

        ToggleVersionsMenu menu ->
            View.MenuManager.toggleVersionsMenu model menu

        CloseMenus ->
            View.MenuManager.closeMenus model

        DisplayNewDocumentPanel ->
            View.MenuManager.displayNewDocumentsPanel model

        CancelNewDocument ->
            View.MenuManager.cancelNewDocument model

        ChooseSearchType searchDomain ->
            chooseSearchDomain model searchDomain

        ChooseSortOrder sortOrder ->
            chooseSortOrder model sortOrder

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
            Nav.Navigation.navigateTo maybepage model

        KeyboardMsg keyMsg ->
            processKeyboardMsg model keyMsg

        DisplayDocumentAttributesPanel ->
            ( { model | documentAttributePanelState = DocumentAttributePanelActive }, Cmd.none )

        Tick newTime ->
            ( { model | time = newTime }, Cmd.none )

        RequestTime ->
            ( model, Task.perform ReceiveTime Time.now )

        RequestStartTime ->
            ( model, Task.perform ReceiveStartTime Time.now )

        ReceiveTime time ->
            ( { model | time = time }, Cmd.none )

        ReceiveStartTime time ->
            ( { model | startTime = time }, Cmd.none )

        Test ->
            ( model, User.Action.getUserListCommmand )


processInfoForElm model infoForElm =
    case infoForElm of
        UserLoginInfo userLoginRecord ->
            ( User.Action.reconnectUser model userLoginRecord, Cmd.none )

        RenderedText renderedText ->
            let
                document =
                    model.currentDocument

                updatedDocument =
                    { document | renderedContent = renderedText }

                nextDocumentList =
                    Document.Utility.updateDocumentList document model.documentList
            in
                ( { model
                    | currentDocument = updatedDocument
                    , documentList = nextDocumentList
                  }
                , Task.perform ReceiveTime Time.now
                )


goToEditorPage model =
    ( { model | page = EditorPage, currentDocumentNeedsToBeSaved = False }, Cmd.none )


goToReaderPage model =
    ( { model | page = ReaderPage, currentDocumentNeedsToBeSaved = False }, Cmd.none )


goToStartPage : Model -> ( Model, Cmd Msg )
goToStartPage model =
    ( { model | page = StartPage, currentDocumentNeedsToBeSaved = False }
    , Cmd.batch
        [ Document.Cmd.getDocuments "" "/public/documents" "id=181" (DocumentMsg << GetDocumentList)
        , Nav.Navigation.setPublicUrlWithId 181
        ]
    )


goToHomePage : Model -> ( Model, Cmd Msg )
goToHomePage model =
    ( { model | page = ReaderPage, currentDocumentNeedsToBeSaved = False }, Document.Cmd.searchWithQueryCmd model Document.Model.PublicDocument <| "key=home&authorname=" ++ (Utility.getUsername model) )


chooseSearchDomain model searchDomain =
    let
        nextModel =
            { model | searchDomain = searchDomain, searchMenuState = SearchMenu MenuInactive, page = Utility.setPage model }
    in
        ( nextModel
        , Document.Cmd.search nextModel
        )


chooseSortOrder model sortOrder =
    let
        nextModel =
            { model | sortOrder = sortOrder, searchMenuState = SearchMenu MenuInactive, page = Utility.setPage model }
    in
        ( nextModel
        , Document.Cmd.search nextModel
        )


processKeyboardMsg model keyMsg =
    let
        pressedKeys =
            Keyboard.Extra.update keyMsg model.pressedKeys
    in
        respondToKeysDispatch model pressedKeys


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
            \model ->
                if model.page == EditorPage then
                    Document.ActionEdit.renderContentAndSave model
                else
                    ( model, Cmd.none )

        CharA ->
            \model ->
                if model.page == EditorPage then
                    ( { model | documentAttributePanelState = DocumentAttributePanelActive }, Cmd.none )
                else
                    ( model, Cmd.none )

        CharC ->
            \model -> View.MenuManager.closeMenus model

        CharE ->
            \model ->
                if model.maybeCurrentUser /= Nothing then
                    goToEditorPage model
                else
                    ( model, Cmd.none )

        CharH ->
            \model -> goToHomePage model

        CharN ->
            \model ->
                if model.page == EditorPage || model.maybeCurrentUser /= Nothing then
                    View.MenuManager.displayNewDocumentsPanel model
                else
                    ( model, Cmd.none )

        CharR ->
            \model -> goToReaderPage model

        CharS ->
            \model -> goToStartPage model

        CharV ->
            \model ->
                if model.page == EditorPage then
                    View.MenuManager.toggleVersionsMenu model model.versionsMenuState
                else
                    ( model, Cmd.none )

        CharX ->
            \model -> Document.ActionRead.getRandomDocuments model

        CharY ->
            \model -> Document.ActionRead.getRecentDocuments model 5

        _ ->
            \model -> ( model, Cmd.none )


headKey : List Key -> Key
headKey keyList =
    List.head keyList |> Maybe.withDefault F24
