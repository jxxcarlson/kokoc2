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
            , RenumberMasterDocument
            , TogglePublic
            , CompileMaster
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
import Utility
import Http


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
                    [ moveRight 330, width (px 150), height (menuHeight model), paddingTop 8, paddingLeft 15, paddingRight 15, paddingBottom 15 ]
                    ([ (toggleDocumentMenuButton model "Document" 60 (DocumentMenu MenuActive))
                     , hairline Hairline
                     , printDocument model
                     ]
                        ++ editingCommmands model
                        ++ [ Widget.hairline, (toggleDocumentMenuButton model "X" 50 (DocumentMenu MenuActive)) ]
                    )


menuHeight model =
    if model.page == EditorPage then
        (px 495)
    else
        (px 130)


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
        , Widget.hairline
        , documentAttributes model
        , togglePublic model
        , Widget.hairline
        , renumberMaster model
        , compileMaster model
        , exportButton model
        , Widget.hairline
        , repositoryDisplay model
        , versionDisplay model
        , showVersionsButton model.currentDocument
        , newVersionButton model.currentDocument
        ]
    else
        []


versionDisplay model =
    el MenuButton [ paddingTop 2, paddingBottom 2 ] (text <| "Version: " ++ (toString model.currentDocument.attributes.version))


archiveName : Model -> Document -> String
archiveName model document =
    let
        maybeParent =
            if model.maybeMasterDocument == Nothing then
                Nothing
            else
                List.head model.documentList

        parentArchiveName =
            case maybeParent of
                Just parent ->
                    parent.attributes.archive

                Nothing ->
                    "default"

        documentArchiveName =
            document.attributes.archive

        archiveName =
            if documentArchiveName /= "default" then
                documentArchiveName
            else if parentArchiveName /= "default" then
                parentArchiveName
            else
                "default"
    in
        archiveName


repositoryDisplay model =
    el MenuButton [ paddingTop 2, paddingBottom 6 ] (text <| "Repository: " ++ archiveName model model.currentDocument)


exportButton model =
    let
        prefix =
            Utility.compress "-" model.currentDocument.title

        fileName =
            prefix ++ ".tex"
    in
        Element.downloadAs { src = dataUrl model.textToExport, filename = fileName } <|
            el MenuButton [ paddingTop 8, paddingBottom 8 ] (text "Export LaTeX")


dataUrl : String -> String
dataUrl data =
    "data:text/plain;charset=utf-8," ++ Http.encodeUri data


compileMaster model =
    Widget.menuButton "Compile Master" 90 [ onClick (DocumentMsg CompileMaster) ] False


renumberMaster model =
    Widget.menuButton "Renumber Master" 90 [ onClick (DocumentMsg RenumberMasterDocument) ] False


printDocument model =
    printButton model.currentDocument


printButton document =
    Widget.linkButton (printUrl document) "Print"


printUrl : Document -> String
printUrl document =
    Configuration.host ++ "/print/documents" ++ "/" ++ toString document.id ++ "?" ++ printTypeString document


newVersionButton1 document =
    newTab (newVersionUrl document) <|
        el MenuButton [ verticalCenter, onClick CloseMenus ] (text "New version")


newVersionButton document =
    Widget.linkButton (newVersionUrl document) "New version"


newVersionUrl : Document -> String
newVersionUrl document =
    Configuration.host ++ "/archive/new_version" ++ "/" ++ toString document.id


showVersionsButton document =
    Widget.linkButton (showVersionsUrl document) "Show versions"


showVersionsUrl : Document -> String
showVersionsUrl document =
    Configuration.host ++ "/archive/versions" ++ "/" ++ toString document.id


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
    Widget.menuButton (publicStatus model) 60 [ onClick (DocumentMsg TogglePublic) ] True


toggleDocumentMenuButton model labelText width msg =
    Widget.menuButton labelText width [ onClick (ToggleDocumentMenu msg) ] False


publicStatus model =
    if model.currentDocument.attributes.public then
        "Public"
    else
        "Private"



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
