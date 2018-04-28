module View.Menubar exposing (view)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick, onInput)
import View.Stylesheet exposing (..)
import Model exposing (Model, Mode(..), Page(..), SearchMenuState(..), DocumentMenuState(..), MenuStatus(..))
import View.Widget as Widget
import Msg exposing (..)
import Document.Msg exposing (DocumentMsg(SearchOnKey, InputSearchQuery, NewDocument))
import Model exposing (Model, Page(..))
import User.Msg exposing (UserMsg(SignIn))
import View.DocumentMenu as DocumentMenu
import View.SearchMenu as SearchMenu


view model =
    Widget.menubar model (menuContent model)


menuContent model =
    [ leftMenu model, centerMenu model, rightMenu model ]


leftMenu model =
    row Menubar
        [ alignLeft, width (fillPortion 33), paddingLeft 20, spacing 12 ]
        [ searchField, SearchMenu.view model, DocumentMenu.view model ]


centerMenu model =
    row Menubar
        [ center, width (fillPortion 35), spacing 8 ]
        [ startPageButton model
        , homePageButton model
        , readerPageButton model
        , editorPageButton model
        , DocumentMenu.newDocumentPanel model
        , DocumentMenu.documentAttributesPanel model
        ]


homePageButton model =
    if model.maybeCurrentUser == Nothing then
        empty
    else
        Widget.button "Home" 75 [ onClick (GotoHomePage) ] False


rightMenu model =
    row Menubar [ alignRight, width (fillPortion 33), paddingRight 20 ] [ signInButton model ]



{- FIELDS -}


searchField =
    el Menubar
        [ paddingTop 2.5 ]
        (Widget.searchField "Search" "" 200 (Msg.DocumentMsg << InputSearchQuery) (Msg.DocumentMsg << SearchOnKey))



{- BUTTONS -}


editorPageButton model =
    if model.maybeCurrentUser == Nothing then
        empty
    else
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
        "Sign out!"
    else
        "Sign in!"



{- MENU -}
