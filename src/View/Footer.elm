module View.Footer exposing (view)

import Element exposing (image, textLayout, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import Element.Input
import Element.Events exposing (onClick, onInput)
import Element.Keyed
import View.Stylesheet exposing (..)
import Model exposing (Model, Mode(..))
import Helper
import View.Widget as Widget


view model =
    Widget.footer model footerContent


footerContent =
    [ el Menubar [ verticalCenter, paddingLeft 20, paddingRight 20 ] (text "Start Page Footer")
    ]
