module View.EditorPage exposing (view)

import Element exposing (image, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import View.Stylesheet exposing (..)
import Model exposing (Model)
import Msg exposing (Msg(DocumentMsg))
import Document.Msg exposing (DocumentMsg(LoadParent, InputEditorText, RenderContent))
import View.Menubar as Menubar
import View.Footer as Footer
import View.Render as Render
import View.TOC as TOC
import View.Widget as Widget
import Element.Events exposing (onClick)


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
        , editorPanel model
        , contentPanel model
        ]


tableOfContentsPanel model =
    column Alternate
        [ width (tableOfContentsWidth model), height fill, paddingTop 30, spacing 15 ]
        [ TOC.view model model.currentDocument model.documentList ]


editorPanel model =
    column Main
        [ alignLeft ]
        [ row Menubar2 [ width (contentsWidth model), height (px 35) ] [ renderContentButton model ]
        , Widget.textArea model.counter (contentsWidth model) (contentsHeight model) "" model.currentDocument.content (DocumentMsg << InputEditorText)
        ]


contentPanel model =
    column Main
        [ alignLeft ]
        [ row Menubar2 [ width (contentsWidth model), height (px 35) ] [ parentButton model ]
        , Render.renderedContent model (contentsWidth model) 105 model.currentDocument
        ]


renderContentButton model =
    Widget.bareButton Button
        "Render"
        90
        [ paddingLeft 10
        , onClick (Msg.DocumentMsg RenderContent)
        ]


parentButton model =
    if model.currentDocument.parentId > 0 && model.maybeMasterDocument == Nothing then
        Widget.bareButton Button
            ("Open: " ++ model.currentDocument.parentTitle)
            400
            [ paddingLeft 10
            , onClick ((Msg.DocumentMsg << LoadParent) model.currentDocument)
            ]
    else
        empty


tableOfContentsHeight model =
    model.windowHeight - 160 |> toFloat


contentsWidth model =
    model.windowWidth
        |> toFloat
        |> (\x -> 0.4 * x)
        |> px


contentsHeight model =
    model.windowHeight - 160 |> toFloat |> px


tableOfContentsWidth model =
    model.windowWidth
        |> toFloat
        |> (\x -> 0.2 * x)
        |> px
