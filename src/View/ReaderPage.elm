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


mainRow model =
    row Alternate
        [ height fill ]
        [ tableOfContentsPanel model
        , contentPanel model
        ]


tableOfContentsPanel model =
    column Alternate
        [ width (fillPortion 30), height fill, paddingTop 30, spacing 15 ]
        [ TOC.view (tableOfContentsWidth model) (tableOfContentsHeight model) model.masterDocumentTitle model.currentDocument model.documentList ]


contentPanel model =
    column Main
        [ alignLeft ]
        [ Render.renderedContent model ]


tableOfContentsHeight model =
    model.windowHeight - 160 |> toFloat


tableOfContentsWidth model =
    model.windowWidth
        |> toFloat
        |> \x -> 0.3 * x - 30
