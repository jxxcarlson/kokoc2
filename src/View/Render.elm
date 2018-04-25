module View.Render exposing (renderedContent)

import Element exposing (Element, image, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import Json.Encode
import Element.Keyed as Keyed
import View.Stylesheet exposing (..)
import Model exposing (Model)
import Document.Model exposing (Document)


renderedContent : Model -> Length -> Float -> Document -> Element MyStyles variation msg
renderedContent model width_ verticalInset document =
    Keyed.row None [] [ ( toString model.counter, innerRenderedContent model width_ verticalInset document ) ]


mainContentHeight : Model -> Float -> Length
mainContentHeight model verticalInset =
    toFloat model.windowHeight - verticalInset |> px


mainContentWidth : Model -> Length
mainContentWidth model =
    model.windowWidth
        |> toFloat
        |> (\x -> 0.7 * x)
        |> px


innerRenderedContent : Model -> Length -> Float -> Document -> Element MyStyles variation msg
innerRenderedContent model width_ verticalInset document =
    el (MainContent)
        [ yScrollbar
        , id "renderedText"
        , paddingXY 50 50
        , width width_
        , height (mainContentHeight model verticalInset)
        , property "innerHTML"
            (Json.Encode.string document.renderedContent)
        ]
        (text "")
