module View.DocumentMenu
    exposing
        ( view
        , newDocumentPanel
        , documentAttributesPanel
        , versionsMenu
        , toggleVersionsMenuButton
        , tagsMenuPanel
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
        , TagsMenuState(..)
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
            , InputTags
            , NewDocument
            , PrepareToDeleteDocument
            , DoDeleteDocument
            , UpdateDocumentAttributes
            , RenumberMasterDocument
            , TogglePublic
            , CompileMaster
            , SetRepositoryName
            , UpdateShareData
            , UpdateTags
            , AdoptChildren
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
            toggleDocumentMenuButton model "Document" 90 (DocumentMenu MenuInactive)

        DocumentMenu MenuActive ->
            (toggleDocumentMenuButton model "Document" 90 (DocumentMenu MenuActive))
                |> below
                    [ if (model.maybeCurrentUser == Nothing || model.page /= EditorPage) then
                        documentMenuWhenNotSignedIn model
                      else
                        documentMenuWhenSignedIn model
                    ]


{-| DOCUMENT MENU
-}
documentMenuWhenNotSignedIn model =
    column Menu
        [ width (px 200), padding 12, spacing 4 ]
        [ hairline Hairline
        , printDocument model
        , newdocumentModelAlt model
        , toggleDocumentMenuButton model "X" 33 (DocumentMenu MenuActive)
        ]


newdocumentModelAlt model =
    if model.maybeCurrentUser == Nothing then
        empty
    else
        newDocument model


documentMenuWhenSignedIn model =
    column Menu
        [ width (px 200), paddingXY 18 4, spacing 0, alignLeft ]
        [ hairline Hairline
        , printDocument model
        , newDocument model
        , deleteDocument model
        , Widget.hairline
        , documentAttributes model
        , togglePublic model
        , Widget.hairline
        , renumberMaster model
        , compileMaster model
        , exportButton model
        , Widget.hairline

        --, toggleDocumentMenuButton model "X" 33 (DocumentMenu MenuActive)
        ]


printDocument model =
    printButton model.currentDocument


printButton document =
    Widget.linkButton (printUrl document) "Print"


printUrl : Document -> String
printUrl document =
    Configuration.host ++ "/print/documents" ++ "/" ++ toString document.id ++ "?" ++ printTypeString document


newDocument model =
    Widget.menuItemButton "New ctrl-N" 160 [ onClick (DisplayNewDocumentPanel) ] False


deleteDocument model =
    case model.deleteDocumentState of
        DeleteDocumentInactive ->
            Widget.menuItemButton "Delete" 160 [ onClick (DocumentMsg PrepareToDeleteDocument) ] False

        DeleteDocumentPending ->
            Widget.menuItemButton "DELETE!" 160 [ onClick (DocumentMsg DoDeleteDocument) ] True


documentAttributes model =
    Widget.menuItemButton "Attributes" 160 [ onClick (DisplayDocumentAttributesPanel) ] False


togglePublic model =
    Widget.menuItemButton (publicStatus model) 160 [ onClick (DocumentMsg TogglePublic) ] True


renumberMaster model =
    Widget.menuItemButton "Renumber Master" 160 [ onClick (DocumentMsg RenumberMasterDocument) ] False


compileMaster model =
    Widget.menuItemButton "Compile Master" 160 [ onClick (DocumentMsg CompileMaster) ] False


exportButton model =
    let
        prefix =
            Utility.compress "-" model.currentDocument.title

        fileName =
            prefix ++ ".tex"
    in
        Element.downloadAs { src = dataUrl model.textToExport, filename = fileName } <|
            el MenuButton [] (text "Export LaTeX")



{- END OF DOCUMENTS MENU -}


tagsMenuPanel model =
    if model.page == EditorPage then
        tagsMenuPanelAux model
    else
        empty


tagsMenuPanelAux model =
    case model.tagsMenuState of
        TagsMenu MenuInactive ->
            toggleTagsMenuButton model "Tags" 60 (TagsMenu MenuInactive)

        TagsMenu MenuActive ->
            textLabel "Tags"
                |> above
                    (tagsMenuAux model)


tagsMenuAux model =
    let
        tagString =
            String.join ", " model.currentDocument.tags
    in
        [ column Menu
            [ width (px 220), padding 10, spacing 10 ]
            [ Widget.textArea model.counter (px 200) (px 400) "Tags" tagString (DocumentMsg << InputTags)
            , row Menu
                [ spacing 10 ]
                [ updateTagsButton model
                , toggleTagsMenuButton model "Cancel" 60 (TagsMenu MenuActive)
                ]
            ]
        ]



-- ++ [ Widget.hairline, (toggleDocumentMenuButton model "X" 50 (DocumentMenu MenuActive)) ]


menuHeight model =
    if model.page == EditorPage then
        (px 700)
    else
        (px 145)


{-| NEW DOCUMENT PANEL
-}
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
                 , Widget.menuItemButton "Asciidoc" 90 [ paddingLeft 20, onClick (SetDocumentTextType Asciidoc) ] (model.documentTextType == Asciidoc)
                 , Widget.menuItemButton "Asciidoc Latex" 90 [ paddingLeft 20, onClick (SetDocumentTextType AsciidocLatex) ] (model.documentTextType == AsciidocLatex)
                 , Widget.menuItemButton "MiniLatex" 90 [ paddingLeft 20, onClick (SetDocumentTextType MiniLatex) ] (model.documentTextType == MiniLatex)
                 , Widget.menuItemButton "Plain" 90 [ paddingBottom 12, paddingLeft 20, onClick (SetDocumentTextType Plain) ] (model.documentTextType == Plain)
                 , hairline Hairline
                 , el Menu [ paddingTop 12 ] (text "Document type")
                 , Widget.menuItemButton "Standard" 125 [ paddingLeft 20, onClick (SetDocumentType Standard) ] (model.documentType == Standard)
                 , Widget.menuItemButton "Master" 125 [ paddingBottom 12, paddingLeft 20, onClick (SetDocumentType Master) ] (model.documentType == Master)
                 ]
                    ++ masterDocuParameters model
                )
    else
        empty


dismissNewDocumentPanel =
    Widget.menuButton "Done" 60 [ onClick (CancelNewDocument) ] False


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
            , Widget.menuItemButton "At top" 90 [ paddingLeft 20, onClick (SetSubdocumentPosition SubdocumentAtTop) ] (model.subdocumentPosition == SubdocumentAtTop)
            , Widget.menuItemButton "Above current" 90 [ paddingLeft 20, onClick (SetSubdocumentPosition SubdocumentAboveCurrent) ] (model.subdocumentPosition == SubdocumentAboveCurrent)
            , Widget.menuItemButton "Below current" 90 [ paddingLeft 20, onClick (SetSubdocumentPosition SubdocumentBelowCurrent) ] (model.subdocumentPosition == SubdocumentBelowCurrent)
            , Widget.menuItemButton "At bottom" 90 [ paddingLeft 20, onClick (SetSubdocumentPosition SubdocumentAtBottom) ] (model.subdocumentPosition == SubdocumentAtBottom)
            , Widget.menuItemButton "Don't insert" 90 [ paddingLeft 20, onClick (SetSubdocumentPosition DoNotAttachSubdocument) ] (model.subdocumentPosition == DoNotAttachSubdocument)
            ]

        Nothing ->
            [ empty ]


{-| DOCUMENT ATTRIBUTES PANEL
-}
documentAttributesPanel model =
    if model.documentAttributePanelState == DocumentAttributePanelActive then
        screen <|
            column Menu
                [ moveRight 560, moveDown 80, width (px 375), height (px 510), padding 25, spacing 2 ]
                [ el Menu [ paddingBottom 8 ] (text "Document attributes")
                , Widget.inputField "Title" model.currentDocument.title 330 (InputNewDocumentTitle)
                , Widget.hairline
                , el Menu [ paddingTop 8 ] (text "Text type")
                , Widget.menuItemButton "Asciidoc" 125 [ paddingLeft 20, onClick (SetDocumentTextType Asciidoc) ] (model.documentTextType == Asciidoc)
                , Widget.menuItemButton "Asciidoc Latex" 125 [ paddingLeft 20, onClick (SetDocumentTextType AsciidocLatex) ] (model.documentTextType == AsciidocLatex)
                , Widget.menuItemButton "MiniLatex" 125 [ paddingLeft 20, onClick (SetDocumentTextType MiniLatex) ] (model.documentTextType == MiniLatex)
                , Widget.menuItemButton "Plain" 125 [ paddingLeft 20, onClick (SetDocumentTextType Plain) ] (model.documentTextType == Plain)
                , Widget.hairline
                , Widget.menuItemButton "Adopt children" 125 [ onClick (DocumentMsg AdoptChildren) ] False
                , Widget.hairline
                , el Menu [ paddingTop 8 ] (text "Document type")
                , Widget.menuItemButton "Standard" 125 [ paddingLeft 20, onClick (SetDocumentType Standard) ] (model.documentType == Standard)
                , Widget.menuItemButton "Master" 125 [ paddingLeft 20, onClick (SetDocumentType Master) ] (model.documentType == Master)
                , Widget.hairline
                , row Menu
                    [ spacing 15 ]
                    [ Widget.strongMenuButton "Update" 125 [ onClick (DocumentMsg UpdateDocumentAttributes) ] False
                    , Widget.strongMenuButton "Cancel" 125 [ onClick (CloseMenus) ] False
                    ]
                ]
    else
        empty


shareDocumentInputPane model =
    Widget.menuInputField "share" (model.shareDocumentCommand) 180 (InputShareDocumentCommand)


shareDocumentButton model =
    Widget.innerMenuButton "Share" 50 [ onClick (DocumentMsg UpdateShareData) ] False


{-| VERSIONW MENU
-}
versionsMenu model =
    case model.versionsMenuState of
        VersionsMenu MenuInactive ->
            toggleVersionsMenuButton model "Tools" 60 (VersionsMenu MenuInactive)

        VersionsMenu MenuActive ->
            (textLabel "Tools")
                |> above
                    (versionsMenuAux model)


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
        , toggleVersionsMenuButton model "X" 60 (VersionsMenu MenuActive)
        ]
    ]


versionDisplay model =
    el MenuButton [] (text <| "Document version: " ++ (toString model.currentDocument.attributes.version))


repositoryNameInputPane model =
    Widget.menuInputField "repository" (Document.Utility.archiveName model model.currentDocument) 180 (InputRepositoryName)


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



{- XXXX -}


dataUrl : String -> String
dataUrl data =
    "data:text/plain;charset=utf-8," ++ Http.encodeUri data


toggleDocumentMenuButton model labelText width msg =
    Widget.menuButton labelText width [ verticalCenter, onClick (ToggleDocumentMenu msg) ] False


toggleTagsMenuButton model labelText width msg =
    Widget.menuButton labelText width [ verticalCenter, onClick (ToggleTagsMenu msg) ] False


updateTagsButton model =
    Widget.menuButton "Update" 60 [ verticalCenter, onClick (DocumentMsg UpdateTags) ] False


toggleVersionsMenuButton model labelText width msg =
    Widget.menuButton labelText width [ paddingLeft 12, verticalCenter, onClick (ToggleVersionsMenu msg) ] False


publicStatus model =
    if model.currentDocument.attributes.public then
        "Public"
    else
        "Private"



{- HELPERS -}


textLabel content =
    el Menu [ paddingTop 8, verticalCenter ] (text <| content)


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
