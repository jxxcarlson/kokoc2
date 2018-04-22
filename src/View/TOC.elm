module View.TOC exposing (view)

import Document.ActionRead
import Document.Model exposing (Document, DocumentAttributes, DocType(..))
import Model exposing (Model)
import Msg exposing (Msg)
import Document.Msg exposing (DocumentMsg(SelectDocument))
import Element exposing (image, textLayout, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick, onInput)
import View.Stylesheet exposing (..)


view : Model -> Document -> List Document -> Element.Element MyStyles variation Msg
view model activeDocument documentList =
    row Alternate
        [ paddingXY 20 20 ]
        (innerTableOfContents model activeDocument documentList)


innerTableOfContents : Model -> Document -> List Document -> List (Element.Element MyStyles variation Msg)
innerTableOfContents model activeDocument documentList =
    [ column Alternate
        []
        [ row TOCHeading [] [ text <| documenTitle model documentList ]
        , column Alternate
            [ width (px <| 0.3 * (toFloat model.windowWidth)), height (px <| toFloat model.windowHeight - 180), yScrollbar ]
            (tocView model activeDocument documentList)
        ]
    ]


documenTitle : Model -> List Document -> String
documenTitle model documentList =
    let
        titleWord =
            if model.masterDocumentTitle == "" then
                "Documents"
            else
                "Contents"
    in
        titleWord ++ " (" ++ (toString <| List.length documentList) ++ ")"



{- GUTS -}


tocView : Model -> Document -> List Document -> List (Element.Element MyStyles variation Msg.Msg)
tocView model activeDocument documentList =
    List.map (viewTitle model activeDocument) documentList


viewTitle : Model -> Document -> Document -> Element.Element MyStyles variation Msg.Msg
viewTitle model activeDocument document =
    row Alternate
        [ verticalCenter, paddingLeft (documentIndentLevel model document) ]
        [ -- documentIndicator document model
          titleDisplay activeDocument document
        ]


documentIndentLevel : Model -> Document -> Float
documentIndentLevel model document =
    let
        level =
            if model.masterDocLoaded then
                (Basics.max 1 document.attributes.level)
            else
                0
    in
        16.0 * toFloat (level - 1)


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
    if document.attributes.docType == Master then
        TOCItemMasterSelected
    else
        TOCItemSelected


normalTOCItemStyle document =
    if document.attributes.docType == Master then
        TOCItemMaster
    else
        TOCItem
