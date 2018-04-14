module View.Menubar exposing (view)

import Element exposing (image, textLayout, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import Element.Input
import Element.Events exposing (onClick, onInput)
import Element.Keyed
import View.Stylesheet exposing (..)
import Model exposing (Model, Mode(..))
import Helper
import View.Widget as Widget
import Msg
import User.Msg
    exposing
        ( UserMsg
            ( SignIn
            )
        )


view model =
    Widget.menubar model (menuContent model)


menuContent model =
    [ leftMenu, centerMenu, rightMenu model ]


leftMenu =
    row Menubar [ alignLeft, width (fillPortion 33), paddingLeft 20 ] [ el Menubar [ verticalCenter, paddingLeft 20, paddingRight 20 ] (text "Yo!  ") ]


centerMenu =
    row Menubar [ center, width (fillPortion 35) ] [ el Menubar [ verticalCenter, paddingLeft 20, paddingRight 20 ] (text "Welcome!  ") ]


rightMenu model =
    row Menubar [ alignRight, width (fillPortion 33), paddingRight 20 ] [ Widget.button (signInButtonLabel model) 75 [ onClick (Msg.UserMsg SignIn) ] False ]


signInButtonLabel model =
    if model.mode == SignedIn then
        "Sign out"
    else
        "Sign in"
