module View.DocumentMenu exposing (view, newDocumentPanel)

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
            , DeleteDocument
            )
        )
import Document.Model exposing (Document, SearchDomain(..))
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
                    [ moveRight 330, width (px 90), height (px 200), paddingTop 8, paddingLeft 15, paddingTop 4 ]
                    ([ (toggleDocumentMenuButton model "Document" 60 (DocumentMenu MenuActive)) ]
                        ++ editingCommmands model
                        ++ [ printDocument model, (toggleDocumentMenuButton model "X" 50 (DocumentMenu MenuActive)) ]
                    )


newDocumentPanel model =
    if model.newDocumentPanelState == NewDocumentPanelActive then
        screen <|
            column Menu
                [ moveRight 390, moveDown 80, width (px 350), height (px 450), padding 15, spacing 10 ]
                [ text "New Document"
                , Widget.inputField "Title" "" 300 (InputNewDocumentTitle)
                , Widget.menuButton "Create" 60 [ onClick (DocumentMsg NewDocument) ] False
                , Widget.menuButton "Cancel" 60 [ onClick (CancelNewDocument) ] False
                ]
    else
        empty


dismissNewDocumentPanel =
    Widget.menuButton "Done" 60 [ onClick (CancelNewDocument) ] False


editingCommmands model =
    if model.page == EditorPage then
        [ newDocument model
        , deleteDocument model
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


deleteDocument model =
    case model.deleteDocumentState of
        DeleteDocumentInactive ->
            Widget.menuButton "Delete" 60 [ onClick (DocumentMsg PrepareToDeleteDocument) ] False

        DeleteDocumentPending ->
            Widget.menuButton "DELETE!" 60 [ onClick (DocumentMsg DeleteDocument) ] True


togglePublic model =
    Widget.menuButton "Public" 60 [ onClick (NoOpz) ] False


toggleDocumentMenuButton model labelText width msg =
    Widget.menuButton labelText width [ onClick (ToggleDocumentMenu msg) ] False



{- HELPERS -}


printTypeString : Document -> String
printTypeString document =
    case document.attributes.textType of
        "plain" ->
            "text=plain"

        "adoc" ->
            "text=adoc"

        "adoc:latex" ->
            "text=adoc_latex"

        "adoc_latex" ->
            "text=adoc_latex"

        "latex" ->
            "text=latex"

        "markdown" ->
            "text=markdown"

        _ ->
            "text=plain"
