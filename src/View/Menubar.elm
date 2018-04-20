module View.Menubar exposing (view)

import Element
    exposing
        ( Element
        , image
        , textLayout
        , paragraph
        , el
        , paragraph
        , newTab
        , row
        , wrappedRow
        , column
        , button
        , link
        , text
        , empty
        , screen
        )
import Element.Attributes exposing (..)
import Element.Input
import Element.Events exposing (onClick, onInput)
import Element.Keyed
import View.Stylesheet exposing (..)
import Model exposing (Model, Mode(..), Page(..), SearchMenuState(..), DocumentMenuState(..), MenuStatus(..))
import Helper
import View.Widget as Widget
import Msg exposing (..)
import Configuration
import Document.Msg exposing (DocumentMsg(SearchOnKey, InputSearchQuery, NewDocument))
import Document.Model exposing (Document, SearchDomain(..))
import Model exposing (Model, Page(..))
import User.Msg exposing (UserMsg(SignIn))
import View.DocumentMenu as DocumentMenu


view model =
    Widget.menubar model (menuContent model)


menuContent model =
    [ leftMenu model, centerMenu model, rightMenu model ]


leftMenu model =
    row Menubar
        [ alignLeft, width (fillPortion 33), paddingLeft 20, spacing 12 ]
        [ searchField, searchMenu model, DocumentMenu.view model ]


centerMenu model =
    row Menubar
        [ center, width (fillPortion 35), spacing 8 ]
        [ startPageButton model
        , readerPageButton model
        , editorPageButton model
        ]


rightMenu model =
    row Menubar [ alignRight, width (fillPortion 33), paddingRight 20 ] [ signInButton model ]



{- FIELDS -}


searchField =
    el Menubar
        [ paddingTop 2.5 ]
        (Widget.searchField "Search" "" 200 (Msg.DocumentMsg << InputSearchQuery) (Msg.DocumentMsg << SearchOnKey))



{- BUTTONS -}


editorPageButton model =
    Widget.button "Edit" 75 [ onClick (GotoEditorPage) ] (model.page == EditorPage)


readerPageButton model =
    Widget.button "Read" 75 [ onClick (GotoReaderPage) ] (model.page == ReaderPage)


startPageButton model =
    Widget.button "Start" 75 [ onClick (GotoStartPage) ] (model.page == StartPage)


signInButton : { a | mode : Mode } -> Element.Element MyStyles variation Msg
signInButton model =
    Widget.button (signInButtonLabel model) 75 [ onClick (Msg.UserMsg SignIn) ] False


signInButtonLabel : { a | mode : Mode } -> String
signInButtonLabel model =
    if model.mode == SignedIn then
        "Sign out"
    else
        "Sign in"



{- MENU -}


searchMenu model =
    case model.searchMenuState of
        SearchMenu MenuInactive ->
            column Menu
                [ width (px 110), height (px 200), spacing 15, paddingTop 4 ]
                [ toggleSearchMenuButton model "Search" 60 (SearchMenu MenuInactive) ]

        SearchMenu MenuActive ->
            screen <|
                column Menu
                    [ moveRight 200, width (px 110), height (px 200), paddingTop 8, paddingLeft 15, paddingTop 4 ]
                    [ (toggleSearchMenuButton model "Search" 60 (SearchMenu MenuActive))
                    , searchPublic model
                    , searchPrivate model
                    , searchAll model
                    , (toggleSearchMenuButton model "X" 50 (SearchMenu MenuActive))
                    ]


searchPublic model =
    Widget.menuButton "Public Docs" 90 [ onClick (ChooseSearchType SearchPublic) ] (model.searchDomain == SearchPublic)


searchPrivate model =
    Widget.menuButton "My Docs" 90 [ onClick (ChooseSearchType SearchPrivate) ] (model.searchDomain == SearchPrivate)


searchAll model =
    Widget.menuButton "All Docs" 90 [ onClick (ChooseSearchType SearchAll) ] (model.searchDomain == SearchAll)


testButton2 =
    Widget.menuButton "Test" 100 [ onClick (Test) ] False


toggleSearchMenuButton model labelText width msg =
    Widget.menuButton labelText width [ onClick (ToggleSearchMenu msg) ] False
