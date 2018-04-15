module View.ReaderPage exposing (view)

import Element exposing (image, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import View.Stylesheet exposing (..)
import Model exposing (Model)
import Msg exposing (Msg)
import View.Menubar as Menubar
import View.Footer as Footer
import View.Render as Render
import View.TOC as TOC


view : Model -> Element.Element MyStyles variation Msg
view model =
    Element.column Alternate
        [ width <| px <| toFloat <| model.windowWidth, height <| px <| toFloat <| model.windowHeight ]
        [ Menubar.view model
        , mainRow model
        , Footer.view model
        ]


tableOfContentsHeight model =
    model.windowHeight - 160 |> toFloat


contentsHeight model =
    model.windowHeight - 160 |> toFloat


tableOfContentsWidth model =
    model.windowWidth
        |> toFloat
        |> \x -> 0.3 * x - 30



-- , row Alternate [ spacing 20, height (fill) ] [ TOC.view model, Render.renderedContent model ]


mainRow model =
    row Alternate
        [ height fill ]
        [ column Alternate
            [ width (fillPortion 30), height fill, paddingTop 30, spacing 15 ]
            [ TOC.view (tableOfContentsWidth model) (tableOfContentsHeight model) model.currentDocument model.documentList ]
        , column Main
            [ alignLeft ]
            [ Render.renderedContent model ]
        ]
