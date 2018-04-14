module View.Menubar exposing (view)

import Element exposing (image, textLayout, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import Element.Input
import Element.Events exposing (onClick, onInput)
import Element.Keyed
import View.Stylesheet exposing (..)
import Model exposing (Model, Mode(..), Page(..))
import Helper
import View.Widget as Widget
import Msg exposing (..)
import Model exposing(Model, Page(..))
import User.Msg
    exposing
        ( UserMsg
            ( SignIn
            )
        )


view model =
    Widget.menubar model (menuContent model)


menuContent model =
    [ leftMenu, centerMenu model, rightMenu model ]


leftMenu =
    row Menubar [ alignLeft, width (fillPortion 33), paddingLeft 20 ] [ el Menubar [ verticalCenter, paddingLeft 20, paddingRight 20 ] (text "Yo!  ") ]


centerMenu model =
    row Menubar [ center, width (fillPortion 35), spacing 5 ] [ readerPageButton model, startPageButton model ]


rightMenu model =
    row Menubar [ alignRight, width (fillPortion 33), paddingRight 20 ] [ signInButton model ]



{- BUTTONS -}


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
