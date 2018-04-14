module View.TOC exposing (view)

import Document.ActionRead
import Document.Model exposing (Document, DocumentAttributes)
import Model exposing (Model)
import Msg exposing (Msg)
import Document.Msg exposing (DocumentMsg(SelectDocument))
import Element exposing (image, textLayout, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick, onInput)
import View.Stylesheet exposing (..)


view : Float -> Float -> Document -> List Document -> Element.Element MyStyles variation Msg
view width_ height_ activeDocument documentList =
    row Alternate
        [ paddingXY 20 20 ]
        (innerTableOfContents width_ height_ activeDocument documentList)


innerTableOfContents : Float -> Float -> Document -> List Document -> List (Element.Element MyStyles variation Msg)
innerTableOfContents width_ height_ activeDocument documentList =
    [ column Alternate
        []
        [ row TOCHeading [] [ text "Documents" ]
        , column Alternate
            [ width (px width_), height (px height_), yScrollbar ]
            (tocView activeDocument documentList)
        ]
    ]



{- GUTS -}


tocView : Document -> List Document -> List (Element.Element MyStyles variation Msg.Msg)
tocView activeDocument documentList =
    List.map (viewTitle activeDocument) documentList


viewTitle : Document -> Document -> Element.Element MyStyles variation Msg.Msg
viewTitle activeDocument document =
    row Alternate
        [ verticalCenter, paddingXY (documentIndentLevel document) 0 ]
        [ -- documentIndicator document model
          titleDisplay activeDocument document
        ]


documentIndentLevel : Document -> Float
documentIndentLevel document =
    let
        level =
            document.attributes.level
    in
        0



-- -12.0 + 16.0 * toFloat (level - 1)


titleDisplay : Document -> Document -> Element.Element MyStyles variation Msg.Msg
titleDisplay selectedDocument document =
    let
        label =
            ""

        --nDocument.TOC.tocLabel document
        title =
            label ++ " " ++ document.title
    in
        el (tocStyle selectedDocument document)
            [ onClick ((Msg.DocumentMsg << SelectDocument) document)
            , paddingXY 0 0
            , height (px 20)
            ]
            (el Alternate [ verticalCenter ] (text title))


tocStyle selectedDocument document =
    if selectedDocument.id == document.id then
        TOCItemSelected
    else if document.content == "Loading ..." then
        TOCItemNotLoaded
    else
        TOCItem
