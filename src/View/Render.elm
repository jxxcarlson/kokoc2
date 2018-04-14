module View.Render exposing (renderedContent)

import Element exposing (Element, image, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import Json.Encode
import Element.Keyed as Keyed
import View.Stylesheet exposing (..)
import Model exposing (Model)


-- renderedContent : Model -> Element Styles variation msg


renderedContent model =
    Keyed.row None [] [ ( toString model.counter, innerRenderedContent model ) ]


mainContentHeight model =
    toFloat model.windowHeight - 50 |> px


mainContentWidth model =
    model.windowWidth
        |> toFloat
        |> (\x -> 0.7 * x)
        |> px


innerRenderedContent model =
    let
        h =
            toFloat model.windowHeight - 50
    in
        el (MainContent)
            [ yScrollbar
            , id "renderedText"
            , paddingXY 50 50
            , width (mainContentWidth model)
            , height (mainContentHeight model)
            , property "innerHTML"
                (Json.Encode.string model.currentDocument.renderedContent)
            ]
            (text "")
