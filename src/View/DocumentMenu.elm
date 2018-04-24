module View.DocumentMenu exposing (view, newDocumentPanel, documentAttributesPanel)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Input
import Element.Events exposing (onClick, onInput)
import Element.Keyed
import View.Stylesheet exposing (..)
import Model
    exposing
        ( Model
        , Mode(..)
        , Page(..)
        , SearchMenuState(..)
        , DocumentMenuState(..)
        , MenuStatus(..)
        , NewDocumentPanelState(..)
        , DeleteDocumentState(..)
        , DocumentAttributePanelState(..)
        , SubdocumentPosition(..)
        )
import Helper
import View.Widget as Widget
import Msg exposing (..)
import Configuration
import Document.Msg
    exposing
        ( DocumentMsg
            ( SearchOnKey
            , InputSearchQuery
            , NewDocument
            , PrepareToDeleteDocument
            , DoDeleteDocument
            , UpdateDocumentAttributes
            )
        )
import Document.Model
    exposing
        ( Document
        , SearchDomain(..)
        , TextType(..)
        , DocType(..)
        )
import User.Msg exposing (UserMsg(SignIn))


view model =
    case model.documentMenuState of
        DocumentMenu MenuInactive ->
            screen <|
                column Menu
                    [ moveRight 340, width (px 80), height (px 35), spacing 15, paddingTop 4 ]
                    [ toggleDocumentMenuButton model "Document" 60 (DocumentMenu MenuInactive) ]

        DocumentMenu MenuActive ->
            screen <|
                column Menu
                    [ moveRight 330, width (px 100), height (px 360), paddingTop 8, paddingLeft 15, paddingBottom 15, spacing 5 ]
                    ([ (toggleDocumentMenuButton model "Document" 60 (DocumentMenu MenuActive)) ]
                        ++ editingCommmands model
                        ++ [ printDocument model, (toggleDocumentMenuButton model "X" 50 (DocumentMenu MenuActive)) ]
                    )


newDocumentPanel model =
    if model.newDocumentPanelState == NewDocumentPanelActive then
        screen <|
            column Menu
                [ moveRight 445, moveDown 80, width (px 350), height (newDocumentMenuHeight model), padding 25, spacing 3 ]
                ([ el Menu [ paddingBottom 8 ] (text "New Document")
                 , Widget.inputField "Title" "" 300 (InputNewDocumentTitle)
                 , Widget.strongMenuButton "Create" 60 [ paddingTop 8, onClick (DocumentMsg NewDocument) ] False
                 , Widget.strongMenuButton "Cancel" 60 [ paddingBottom 12, paddingTop 6, onClick (CancelNewDocument) ] False
                 , hairline Hairline
                 , el Menu [ paddingTop 12 ] (text "Text type")
                 , Widget.menuButton "Asciidoc" 90 [ paddingLeft 20, onClick (SetDocumentTextType Asciidoc) ] (model.documentTextType == Asciidoc)
                 , Widget.menuButton "Asciidoc Latex" 90 [ paddingLeft 20, onClick (SetDocumentTextType AsciidocLatex) ] (model.documentTextType == AsciidocLatex)
                 , Widget.menuButton "MiniLatex" 90 [ paddingLeft 20, onClick (SetDocumentTextType MiniLatex) ] (model.documentTextType == MiniLatex)
                 , Widget.menuButton "Plain" 90 [ paddingBottom 12, paddingLeft 20, onClick (SetDocumentTextType Plain) ] (model.documentTextType == Plain)
                 , hairline Hairline
                 , el Menu [ paddingTop 12 ] (text "Document type")
                 , Widget.menuButton "Standard" 125 [ paddingLeft 20, onClick (SetDocumentType Standard) ] (model.documentType == Standard)
                 , Widget.menuButton "Master" 125 [ paddingBottom 12, paddingLeft 20, onClick (SetDocumentType Master) ] (model.documentType == Master)
                 ]
                    ++ masterDocuParameters model
                )
    else
        empty


newDocumentMenuHeight : Model -> Length
newDocumentMenuHeight model =
    if model.maybeMasterDocument == Nothing then
        480 |> px
    else
        615 |> px


masterDocuParameters model =
    case model.maybeMasterDocument of
        Just masterDocument ->
            [ hairline Hairline
            , el Menu [ paddingTop 12 ] (text "Insert new document")
            , Widget.menuButton "At top" 90 [ paddingLeft 20, onClick (SetSubdocumentPosition SubdocumentAtTop) ] (model.subdocumentPosition == SubdocumentAtTop)
            , Widget.menuButton "Above current" 90 [ paddingLeft 20, onClick (SetSubdocumentPosition SubdocumentAboveCurrent) ] (model.subdocumentPosition == SubdocumentAboveCurrent)
            , Widget.menuButton "Below current" 90 [ paddingLeft 20, onClick (SetSubdocumentPosition SubdocumentBelowCurrent) ] (model.subdocumentPosition == SubdocumentBelowCurrent)
            , Widget.menuButton "At bottom" 90 [ paddingLeft 20, onClick (SetSubdocumentPosition SubdocumentAtBottom) ] (model.subdocumentPosition == SubdocumentAtBottom)
            , Widget.menuButton "Don't insert" 90 [ paddingLeft 20, onClick (SetSubdocumentPosition DoNotAttachSubdocument) ] (model.subdocumentPosition == DoNotAttachSubdocument)
            ]

        Nothing ->
            [ empty ]


documentAttributesPanel model =
    if model.documentAttributePanelState == DocumentAttributePanelActive then
        screen <|
            column Menu
                [ moveRight 430, moveDown 80, width (px 300), height (px 480), padding 25, spacing 4 ]
                [ el Menu [ paddingBottom 8 ] (text "Document attributes")
                , Widget.inputField "Title" model.newDocumentTitle 300 (InputNewDocumentTitle)
                , el Menu [ paddingTop 12 ] (text "Text type")
                , Widget.menuButton "Asciidoc" 125 [ paddingLeft 20, onClick (SetDocumentTextType Asciidoc) ] (model.documentTextType == Asciidoc)
                , Widget.menuButton "Asciidoc Latex" 125 [ paddingLeft 20, onClick (SetDocumentTextType AsciidocLatex) ] (model.documentTextType == AsciidocLatex)
                , Widget.menuButton "MiniLatex" 125 [ paddingLeft 20, onClick (SetDocumentTextType MiniLatex) ] (model.documentTextType == MiniLatex)
                , Widget.menuButton "Plain" 125 [ paddingLeft 20, onClick (SetDocumentTextType Plain) ] (model.documentTextType == Plain)
                , Widget.menuButton "Update" 125 [ onClick (DocumentMsg UpdateDocumentAttributes) ] False
                , el Menu [ paddingTop 12 ] (text "Document type")
                , Widget.menuButton "Standard" 125 [ paddingLeft 20, onClick (SetDocumentType Standard) ] (model.documentType == Standard)
                , Widget.menuButton "Master" 125 [ paddingLeft 20, onClick (SetDocumentType Master) ] (model.documentType == Master)
                , Widget.menuButton "Update" 125 [ paddingTop 24, onClick (DocumentMsg UpdateDocumentAttributes) ] False
                , Widget.menuButton "Cancel" 125 [ paddingBottom 25, paddingTop 20, onClick (CloseMenus) ] False
                ]
    else
        empty


dismissNewDocumentPanel =
    Widget.menuButton "Done" 60 [ onClick (CancelNewDocument) ] False


editingCommmands model =
    if model.page == EditorPage then
        [ newDocument model
        , deleteDocument model
        , documentAttributes model
        , togglePublic model
        ]
    else
        []


printDocument model =
    printButton model.currentDocument


printButton document =
    newTab (printUrl document) <|
        el MenuButton [ paddingTop 6, paddingBottom 8, verticalCenter, onClick CloseMenus ] (text "Print")


printUrl : Document -> String
printUrl document =
    Configuration.host ++ "/print/documents" ++ "/" ++ toString document.id ++ "?" ++ printTypeString document


newDocument model =
    Widget.menuButton "New" 60 [ onClick (DisplayNewDocumentPanel) ] False


documentAttributes model =
    Widget.menuButton "Attributes" 60 [ onClick (DisplayDocumentAttributesPanel) ] False


deleteDocument model =
    case model.deleteDocumentState of
        DeleteDocumentInactive ->
            Widget.menuButton "Delete" 60 [ onClick (DocumentMsg PrepareToDeleteDocument) ] False

        DeleteDocumentPending ->
            Widget.menuButton "DELETE!" 60 [ onClick (DocumentMsg DoDeleteDocument) ] True


togglePublic model =
    Widget.menuButton "Public" 60 [ onClick (NoOpz) ] False


toggleDocumentMenuButton model labelText width msg =
    Widget.menuButton labelText width [ onClick (ToggleDocumentMenu msg) ] False



{- HELPERS -}


printTypeString : Document -> String
printTypeString document =
    case document.attributes.textType of
        Asciidoc ->
            "text=adoc"

        AsciidocLatex ->
            "text=adoc_latex"

        MiniLatex ->
            "text=latex"

        Plain ->
            "text=latex"
