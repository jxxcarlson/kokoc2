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
import Msg exposing (Msg(Test))


view model =
    Widget.footer model footerContent


footerContent =
    [ testButton
    ]


testButton =
    Widget.button "Test" 75 [ onClick (Test) ] False
