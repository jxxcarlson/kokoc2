module View.Widget exposing (..)

import Element exposing (viewport, image, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import Element.Input
import Element.Events exposing (onClick, onInput)
import Element.Keyed
import View.Stylesheet exposing (..)


xcolumn columnStyle widthExpression attributes content =
    Element.column columnStyle (widthExpression :: attributes) [ content ]


menubar model menuContent =
    row Menubar
        [ width (percent 100), height (px 35), center ]
        menuContent


footer model footerContent =
    row Menubar
        [ width (percent 100), height (px 35), center, alignBottom ]
        footerContent
