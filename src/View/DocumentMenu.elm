module View.DocumentMenu
    exposing
        ( view
        , newDocumentPanel
        , documentAttributesPanel
        , versionsMenu
        , toggleVersionsMenuButton
        )

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
        , VersionsMenuState(..)
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
            , SetRepositoryName
            , UpdateShareData
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
import Document.Utility
import View.MenuManager as MenuManager


view model =
    case model.documentMenuState of
        DocumentMenu MenuInactive ->
            toggleDocumentMenuButton model "Document" 60 (DocumentMenu MenuInactive)

        DocumentMenu MenuActive ->
            (toggleDocumentMenuButton model "Document" 60 (DocumentMenu MenuActive))
                |> below
                    [ if model.maybeCurrentUser == Nothing then
                        documentMenuWhenNotSignedIn model
                      else
                        documentMenuWhenSignedIn model
                    ]


documentMenuWhenNotSignedIn model =
    column Menu
        [ width (px 200), padding 12, spacing 4 ]
        [ hairline Hairline
        , printDocument model
        , toggleDocumentMenuButton model "X" 33 (DocumentMenu MenuActive)
        ]


documentMenuWhenSignedIn model =
    column Menu
        [ width (px 200), padding 12, spacing 4 ]
        [ hairline Hairline
        , printDocument model
        , newDocument model
        , deleteDocument model
        , Widget.hairline
        , documentAttributesPanel model
        , documentAttributes model
        , togglePublic model
        , Widget.hairline
        , renumberMaster model
        , compileMaster model
        , exportButton model
        , Widget.hairline

        --, toggleDocumentMenuButton model "X" 33 (DocumentMenu MenuActive)
        ]


versionsMenu model =
    case model.versionsMenuState of
        VersionsMenu MenuInactive ->
            toggleVersionsMenuButton model "Tools" 60 (VersionsMenu MenuInactive)

        VersionsMenu MenuActive ->
            toggleVersionsMenuButton model "Tools" 60 (VersionsMenu MenuActive)
                |> above
                    (versionsMenuAux model)


textLabel content =
    el Menu [ paddingTop 8, verticalCenter ] (text <| content)


versionsMenuAux model =
    [ column Menu
        [ width (px 220), padding 18, spacing 6 ]
        [ versionDisplay model
        , showVersionsButton model.currentDocument
        , newVersionButton model.currentDocument
        , textLabel <| "Repository:"
        , repositoryNameInputPane model
        , setRepository model
        , Widget.hairline
        , textLabel <| "Sharing"
        , shareDocumentInputPane model
        , shareDocumentButton model
        ]
    ]



-- ++ [ Widget.hairline, (toggleDocumentMenuButton model "X" 50 (DocumentMenu MenuActive)) ]


menuHeight model =
    if model.page == EditorPage then
        (px 700)
    else
        (px 145)


newDocumentPanel model =
    if model.newDocumentPanelState == NewDocumentPanelActive then
        screen <|
            column Menu
                [ moveRight 445, moveDown 80, width (px 350), height (newDocumentMenuHeight model), padding 25, spacing 3 ]
                ([ el Menu [ paddingBottom 8 ] (text "New Document")
                 , Widget.inputField "Title" "" 300 (InputNewDocumentTitle)
                 , Widget.strongMenuButton "Create" 60 [ onClick (DocumentMsg NewDocument) ] False
                 , Widget.strongMenuButton "Cancel" 60 [ onClick (CancelNewDocument) ] False
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
                [ moveRight 560, moveDown 80, width (px 375), height (px 450), padding 25, spacing 2 ]
                [ el Menu [ paddingBottom 8 ] (text "Document attributes")
                , Widget.inputField "Title" model.newDocumentTitle 330 (InputNewDocumentTitle)
                , Widget.hairline
                , el Menu [ paddingTop 8 ] (text "Text type")
                , Widget.menuButton "Asciidoc" 125 [ paddingLeft 20, onClick (SetDocumentTextType Asciidoc) ] (model.documentTextType == Asciidoc)
                , Widget.menuButton "Asciidoc Latex" 125 [ paddingLeft 20, onClick (SetDocumentTextType AsciidocLatex) ] (model.documentTextType == AsciidocLatex)
                , Widget.menuButton "MiniLatex" 125 [ paddingLeft 20, onClick (SetDocumentTextType MiniLatex) ] (model.documentTextType == MiniLatex)
                , Widget.menuButton "Plain" 125 [ paddingLeft 20, onClick (SetDocumentTextType Plain) ] (model.documentTextType == Plain)
                , Widget.hairline
                , el Menu [ paddingTop 8 ] (text "Document type")
                , Widget.menuButton "Standard" 125 [ paddingLeft 20, onClick (SetDocumentType Standard) ] (model.documentType == Standard)
                , Widget.menuButton "Master" 125 [ paddingLeft 20, onClick (SetDocumentType Master) ] (model.documentType == Master)
                , Widget.hairline
                , row Menu
                    [ spacing 15 ]
                    [ Widget.strongMenuButton "Update" 125 [ onClick (DocumentMsg UpdateDocumentAttributes) ] False
                    , Widget.strongMenuButton "Cancel" 125 [ onClick (CloseMenus) ] False
                    ]
                ]
    else
        empty


dismissNewDocumentPanel =
    Widget.menuButton "Done" 60 [ onClick (CancelNewDocument) ] False


shareDocumentInputPane model =
    Widget.menuInputField "share" (model.shareDocumentCommand) 180 (InputShareDocumentCommand)


shareDocumentButton model =
    Widget.innerMenuButton "Share" 50 [ onClick (DocumentMsg UpdateShareData) ] False


versionDisplay model =
    el MenuButton [] (text <| "Document version: " ++ (toString model.currentDocument.attributes.version))


repositoryNameInputPane model =
    Widget.menuInputField "repository" (Document.Utility.archiveName model model.currentDocument) 180 (InputRepositoryName)


exportButton model =
    let
        prefix =
            Utility.compress "-" model.currentDocument.title

        fileName =
            prefix ++ ".tex"
    in
        Element.downloadAs { src = dataUrl model.textToExport, filename = fileName } <|
            el MenuButton [] (text "Export LaTeX")


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


newVersionButton document =
    Widget.linkButton (newVersionUrl document) "New version"


setRepository model =
    Widget.innerMenuButton "Set" 35 [ onClick (DocumentMsg SetRepositoryName) ] False


newVersionUrl : Document -> String
newVersionUrl document =
    Configuration.host ++ "/archive/new_version" ++ "/" ++ toString document.id


showVersionsButton document =
    Widget.linkButton (showVersionsUrl document) "Show versions"


showVersionsUrl : Document -> String
showVersionsUrl document =
    Configuration.host ++ "/archive/versions" ++ "/" ++ toString document.id


newDocument model =
    Widget.menuButton "New ctrl-N" 60 [ onClick (DisplayNewDocumentPanel) ] False


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
    Widget.menuButton labelText width [ verticalCenter, onClick (ToggleDocumentMenu msg) ] False


toggleVersionsMenuButton model labelText width msg =
    Widget.menuButton labelText width [ paddingLeft 12, verticalCenter, onClick (ToggleVersionsMenu msg) ] False


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
