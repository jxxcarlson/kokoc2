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
        [ width (percent 100), height (px 35) ]
        menuContent


footer model footerContent =
    row Menubar
        [ width (percent 100), height (px 35), alignBottom ]
        footerContent


button title width_ attrs selected =
    if selected then
        el ButtonSelected ([ paddingLeft 8, paddingTop 8, height (px 34), width (px width_), center ] ++ attrs) (el None [ center ] (text title))
    else
        el Button ([ paddingLeft 8, paddingTop 8, height (px 34), width (px width_) ] ++ attrs) (el None [ center ] (text title))
