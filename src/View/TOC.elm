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


view : Float -> Float -> String -> Document -> List Document -> Element.Element MyStyles variation Msg
view width_ height_ title activeDocument documentList =
    row Alternate
        [ paddingXY 20 20 ]
        (innerTableOfContents width_ height_ title activeDocument documentList)


innerTableOfContents : Float -> Float -> String -> Document -> List Document -> List (Element.Element MyStyles variation Msg)
innerTableOfContents width_ height_ title activeDocument documentList =
    [ column Alternate
        []
        [ row TOCHeading [] [ text <| documenTitle title documentList ]
        , column Alternate
            [ width (px width_), height (px height_), yScrollbar ]
            (tocView activeDocument documentList)
        ]
    ]


documenTitle : String -> List Document -> String
documenTitle title documentList =
    let
        titleWord =
            if title == "" then
                "Documents"
            else
                "Contents"
    in
        titleWord ++ " (" ++ (toString <| List.length documentList) ++ ")"



{- GUTS -}


tocView : Document -> List Document -> List (Element.Element MyStyles variation Msg.Msg)
tocView activeDocument documentList =
    List.map (viewTitle activeDocument) documentList


viewTitle : Document -> Document -> Element.Element MyStyles variation Msg.Msg
viewTitle activeDocument document =
    row Alternate
        [ verticalCenter, paddingLeft (documentIndentLevel document) ]
        [ -- documentIndicator document model
          titleDisplay activeDocument document
        ]


documentIndentLevel : Document -> Float
documentIndentLevel document =
    let
        level =
            Debug.log "Level"
                (Basics.min 1 document.attributes.level)
    in
        16.0 * toFloat level


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
        selectedTOCItemStyle document
    else if String.left 7 document.content == "Loading" then
        TOCItemNotLoaded
    else
        normalTOCItemStyle document


selectedTOCItemStyle document =
    if document.attributes.docType == "master" then
        TOCItemMasterSelected
    else
        TOCItemSelected


normalTOCItemStyle document =
    if document.attributes.docType == "master" then
        TOCItemMaster
    else
        TOCItem
