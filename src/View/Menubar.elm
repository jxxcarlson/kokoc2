module View.Menubar exposing (view)

import Element
    exposing
        ( Element
        , image
        , textLayout
        , paragraph
        , el
        , paragraph
        , newTab
        , row
        , wrappedRow
        , column
        , button
        , link
        , text
        , empty
        , screen
        )
import Element.Attributes exposing (..)
import Element.Input
import Element.Events exposing (onClick, onInput)
import Element.Keyed
import View.Stylesheet exposing (..)
import Model exposing (Model, Mode(..), Page(..), SearchMenuState(..), DocumentMenuState(..), MenuStatus(..))
import Helper
import View.Widget as Widget
import Msg exposing (..)
import Configuration
import Document.Msg exposing (DocumentMsg(SearchOnKey, InputSearchQuery))
import Document.Model exposing (Document, SearchDomain(..))
import Model exposing (Model, Page(..))
import User.Msg exposing (UserMsg(SignIn))


view model =
    Widget.menubar model (menuContent model)


menuContent model =
    [ leftMenu model, centerMenu model, rightMenu model ]


leftMenu model =
    row Menubar
        [ alignLeft, width (fillPortion 33), paddingLeft 20, spacing 12 ]
        [ searchField, searchMenu model, documentMenu model ]


centerMenu model =
    row Menubar [ center, width (fillPortion 35), spacing 5 ] [ readerPageButton model, startPageButton model ]


rightMenu model =
    row Menubar [ alignRight, width (fillPortion 33), paddingRight 20 ] [ signInButton model ]



{- FIELDS -}


searchField =
    el Menubar
        [ paddingTop 2.5 ]
        (Widget.searchField "Search" "" 200 (Msg.DocumentMsg << InputSearchQuery) (Msg.DocumentMsg << SearchOnKey))



{- BUTTONS -}


readerPageButton model =
    Widget.button "Read" 75 [ onClick (GotoReaderPage) ] (model.page == ReaderPage)


startPageButton model =
    Widget.button "Start" 75 [ onClick (GotoStartPage) ] (model.page == StartPage)


signInButton : { a | mode : Mode } -> Element.Element MyStyles variation Msg
signInButton model =
    Widget.button (signInButtonLabel model) 75 [ onClick (Msg.UserMsg SignIn) ] False


signInButtonLabel : { a | mode : Mode } -> String
signInButtonLabel model =
    if model.mode == SignedIn then
        "Sign out"
    else
        "Sign in"



{- MENU -}


documentMenu model =
    case model.documentMenuState of
        DocumentMenu MenuInactive ->
            screen <|
                column Menu
                    [ moveRight 350, width (px 120), height (px 35), spacing 15 ]
                    [ toggleDocumentMenuButton model "Document" 60 (DocumentMenu MenuInactive) ]

        DocumentMenu MenuActive ->
            screen <|
                column Menu
                    [ moveRight 340, width (px 120), height (px 200), paddingTop 8, paddingLeft 15 ]
                    [ (toggleDocumentMenuButton model "Document" 60 (DocumentMenu MenuActive))
                    , printDocument model
                    , (toggleDocumentMenuButton
                        model
                        "X"
                        50
                        (DocumentMenu MenuActive)
                      )
                    ]


printDocument model =
    printButton model.currentDocument


searchMenu model =
    case model.searchMenuState of
        SearchMenu MenuInactive ->
            column Menu
                [ width (px 120), height (px 200), spacing 15 ]
                [ toggleSearchMenuButton model "Search" 60 (SearchMenu MenuInactive) ]

        SearchMenu MenuActive ->
            screen <|
                column Menu
                    [ moveRight 200, width (px 120), height (px 200), paddingTop 8, paddingLeft 15 ]
                    [ (toggleSearchMenuButton model "Search" 60 (SearchMenu MenuActive))
                    , searchPublic model
                    , searchPrivate model
                    , searchAll model
                    , (toggleSearchMenuButton model "X" 50 (SearchMenu MenuActive))
                    ]


searchPublic model =
    Widget.squareButton "Public Docs" 100 [ onClick (ChooseSearchType SearchPublic) ] (model.searchDomain == SearchPublic)


searchPrivate model =
    Widget.squareButton "My Docs" 100 [ onClick (ChooseSearchType SearchPrivate) ] (model.searchDomain == SearchPrivate)


searchAll model =
    Widget.squareButton "All Docs" 100 [ onClick (ChooseSearchType SearchAll) ] (model.searchDomain == SearchAll)


testButton2 =
    Widget.squareButton "Test" 100 [ onClick (Test) ] False


toggleDocumentMenuButton model labelText width msg =
    Widget.squareButton labelText width [ onClick (ToggleDocumentMenu msg) ] False


toggleSearchMenuButton model labelText width msg =
    Widget.squareButton labelText width [ onClick (ToggleSearchMenu msg) ] False



{- PRINT -}
-- printButton : Document -> Element Styles variation Msg


printButton document =
    newTab (printUrl document) <|
        el Menu [ verticalCenter, onClick CloseMenus ] (text "Print")



-- link (printUrl document) <|
--         el Zero [ verticalCenter, target "_blank" ] (html (FontAwesome.print Color.white 25))
-- link "http://zombo.com"
--     <| el MyStyle (text "Welcome to Zombocom")


printUrl : Document -> String
printUrl document =
    Configuration.host ++ "/print/documents" ++ "/" ++ toString document.id ++ "?" ++ printTypeString document


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



-- Widget.button labelText 75 [ onClick (ToggleSearchMenu <| SearchMenu model.searchMenuState) ] False
