module View.ReaderPage exposing (view)

import Element exposing (image, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import View.Stylesheet exposing (..)
import Model exposing (Model)
import Msg exposing (Msg)
import Document.Msg exposing (DocumentMsg(LoadParent))
import View.Menubar as Menubar
import View.Footer as Footer
import View.Render as Render
import View.TOC as TOC
import View.Widget as Widget
import Element.Events exposing (onClick)


view : Model -> Element.Element MyStyles variation Msg
view model =
    Element.column Alternate
        [ width fill, height <| px <| toFloat <| model.windowHeight ]
        [ Menubar.view model
        , Element.hairline Hairline
        , mainRow model
        , Footer.view model
        ]


mainContentWidth model =
    model.windowWidth
        |> toFloat
        |> (\x -> 0.7 * x)
        |> px


mainRow model =
    row Alternate
        [ width fill, height fill ]
        [ tableOfContentsPanel model
        , contentPanel model
        ]


tableOfContentsPanel model =
    column Alternate
        [ width (tableOfContentsWidth model), height fill, paddingTop 30, spacing 15 ]
        [ TOC.view model model.currentDocument model.documentList ]


contentPanel model =
    column Main
        [ alignLeft ]
        [ row Menubar2 [ width fill, height (px 35) ] [ parentButton model, docInfo model ]
        , Render.renderedContent model (contentsWidth model) 105 model.currentDocument
        ]


docInfo model =
    let
        author =
            model.currentDocument.authorName

        id =
            toString model.currentDocument.id

        message =
            author ++ ", doc id = " ++ id
    in
        el Menubar2 [ paddingTop 10, paddingLeft 10 ] (text message)


tableOfContentsWidth model =
    model.windowWidth
        |> toFloat
        |> (\x -> 0.2 * x)
        |> px


contentsWidth model =
    model.windowWidth
        |> toFloat
        |> (\x -> Basics.max 700 (0.4 * x))
        |> px


parentButton model =
    if model.currentDocument.parentId > 0 && model.maybeMasterDocument == Nothing then
        Widget.bareButton StrongButton
            ("Open: " ++ model.currentDocument.parentTitle)
            400
            [ paddingLeft 10
            , onClick ((Msg.DocumentMsg << LoadParent) model.currentDocument)
            ]
    else
        empty


tableOfContentsHeight model =
    model.windowHeight - 160 |> toFloat
