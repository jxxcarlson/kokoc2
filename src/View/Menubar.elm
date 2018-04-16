module View.Menubar exposing (view)

import Element
    exposing
        ( image
        , textLayout
        , paragraph
        , el
        , paragraph
        , newTab
        , row
        , wrappedRow
        , column
        , button
        , text
        , empty
        , screen
        )
import Element.Attributes exposing (..)
import Element.Input
import Element.Events exposing (onClick, onInput)
import Element.Keyed
import View.Stylesheet exposing (..)
import Model exposing (Model, Mode(..), Page(..), MenuState(..), MenuStatus(..))
import Helper
import View.Widget as Widget
import Msg exposing (..)
import Document.Msg exposing (DocumentMsg(SearchOnKey, InputSearchQuery))
import Document.Model exposing (SearchDomain(..))
import Model exposing (Model, Page(..))
import User.Msg
    exposing
        ( UserMsg
            ( SignIn
            )
        )


view model =
    Widget.menubar model (menuContent model)


menuContent model =
    [ leftMenu model, centerMenu model, rightMenu model ]


leftMenu model =
    row Menubar [ alignLeft, width (fillPortion 33), paddingLeft 20, spacing 12 ] [ searchField, toolsMenu model ]


centerMenu model =
    row Menubar [ center, width (fillPortion 35), spacing 5 ] [ readerPageButton model, startPageButton model ]


rightMenu model =
    row Menubar [ alignRight, width (fillPortion 33), paddingRight 20 ] [ signInButton model ]



{- FIELDS -}


searchField =
    el Menubar
        [ paddingTop 2.5 ]
        (Widget.searchField "Search" "" 200 (Msg.DocumentMsg << InputSearchQuery) (Msg.DocumentMsg << SearchOnKey))



{- BUTTONS -}


testButton =
    Widget.button "Test" 75 [ onClick (Test) ] False


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


fooMenu1 model =
    column Menubar
        [ width (px 200), height (px 200), spacing 15 ]
        [ text "AAA" ]


toolsMenu model =
    case model.menuAState of
        MenuA MenuInactive ->
            column Menu
                [ width (px 200), height (px 200), spacing 15 ]
                [ toggleButton model "Search" 60 (MenuA MenuInactive) ]

        MenuA MenuActive ->
            screen <|
                column Menu
                    [ moveRight 200, width (px 200), height (px 200), paddingTop 8, paddingLeft 15 ]
                    [ (toggleButton model "Search" 150 (MenuA MenuActive))
                    , searchPublic model
                    , searchPrivate model
                    , searchAll model
                    , (toggleButton model "X" 50 (MenuA MenuActive))
                    ]


searchPublic model =
    Widget.squareButton "Public Docs" 100 [ onClick (ChooseSearchType SearchPublic) ] (model.searchDomain == SearchPublic)


searchPrivate model =
    Widget.squareButton "My Docs" 100 [ onClick (ChooseSearchType SearchPrivate) ] (model.searchDomain == SearchPrivate)


searchAll model =
    Widget.squareButton "All Docs" 100 [ onClick (ChooseSearchType SearchAll) ] (model.searchDomain == SearchAll)


testButton2 =
    Widget.squareButton "Test" 100 [ onClick (Test) ] False


toggleButton model labelText width msg =
    Widget.squareButton labelText width [ onClick (ToggleMenu msg) ] False



-- Widget.button labelText 75 [ onClick (ToggleMenu <| MenuA model.menuAState) ] False
