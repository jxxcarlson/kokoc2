module View.Main exposing (view)

import Element exposing (viewport)
import Element.Attributes exposing (..)
import View.Stylesheet exposing (..)
import Model exposing (Model, Page(..))
import View.StartPage as StartPage
import View.ReaderPage as ReaderPage
import View.EditorPage as EditorPage
import View.AdminPage as AdminPage
import Html
import Msg exposing (Msg)


view : Model -> Html.Html Msg
view model =
    Element.viewport stylesheet <|
        Element.column Main
            [ width fill, height <| px <| toFloat <| model.windowHeight, clip ]
            [ dispatcher model
            ]


dispatcher model =
    case model.page of
        StartPage ->
            StartPage.view model

        ReaderPage ->
            ReaderPage.view model

        EditorPage ->
            EditorPage.view model

        AdminPage ->
            AdminPage.view model

        UrlPage _ ->
            ReaderPage.view model
