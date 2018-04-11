module View.Widget exposing (..)

import Element exposing (viewport, image, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import Element.Input
import Element.Events exposing (onClick, onInput)
import Element.Keyed
import Html.Attributes
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


formButton title width_ attrs selected =
    if selected then
        el FormButtonSelected ([ paddingLeft 8, paddingTop 8, height (px 34), width (px width_), center ] ++ attrs) (el None [ center ] (text title))
    else
        el FormButton ([ paddingLeft 8, paddingTop 8, height (px 34), width (px width_) ] ++ attrs) (el None [ center ] (text title))


inputField label_ value_ width_ action =
    Element.Input.text InputField
        [ width (px width_)
        , height (px 30)
        , paddingLeft 5
        , Element.Attributes.toAttr (Html.Attributes.attribute "autocorrect" "off")
        ]
        { onChange = action
        , value = value_
        , label = Element.Input.placeholder { text = label_, label = Element.Input.labelLeft Element.empty }
        , options = []
        }


doNotAutocapitalize =
    Element.Attributes.toAttr (Html.Attributes.attribute "autocapitalize" "none")
