module View.SearchMenu exposing (view)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick, onInput)
import View.Stylesheet exposing (..)
import Model exposing (Model, Mode(..), Page(..), SearchMenuState(..), DocumentMenuState(..), MenuStatus(..))
import View.Widget as Widget
import Msg exposing (..)
import Document.Model exposing (Document, SearchDomain(..), SortOrder(..), DocumentAccessibility(..))
import Model exposing (Model, Page(..), SearchMenuState(..))
import Document.Msg exposing (DocumentMsg(GetRandomDocuments, GetRecentDocuments))


view model =
    case model.searchMenuState of
        SearchMenu MenuInactive ->
            column Menu
                [ width (px 110), height (px 200), spacing 15, paddingTop 4 ]
                [ toggleSearchMenuButton model "Search" 90 (SearchMenu MenuInactive) ]

        SearchMenu MenuActive ->
            screen <|
                column Menu
                    [ moveRight 200, width (px 150), height (px 400), paddingTop 8, paddingLeft 15, paddingRight 15, paddingTop 4 ]
                    [ (toggleSearchMenuButton model "Search" 90 (SearchMenu MenuActive))
                    , hairline Hairline
                    , randomSearch model
                    , recentDocuments model
                    , Widget.hairline
                    , searchPublic model
                    , searchPrivate model
                    , searchAll model
                    , Widget.hairline
                    , orderByViewed model
                    , orderByUpdated model
                    , orderByCreated model
                    , orderAlphabetically model
                    , Widget.hairline
                    , (toggleSearchMenuButton model "X" 50 (SearchMenu MenuActive))
                    ]


orderByViewed model =
    Widget.menuItemButton "Viewed" 90 [ onClick (ChooseSortOrder ViewedOrder) ] (model.sortOrder == ViewedOrder)


orderByUpdated model =
    Widget.menuItemButton "Updated" 90 [ onClick (ChooseSortOrder UpdatedOrder) ] (model.sortOrder == UpdatedOrder)


orderByCreated model =
    Widget.menuItemButton "Created" 90 [ onClick (ChooseSortOrder CreatedOrder) ] (model.sortOrder == CreatedOrder)


orderAlphabetically model =
    Widget.menuItemButton "Alphabetical" 90 [ onClick (ChooseSortOrder AlphabeticalOrder) ] (model.sortOrder == AlphabeticalOrder)


randomSearch model =
    Widget.menuItemButton "Random Docs" 90 [ paddingTop 12, onClick (DocumentMsg GetRandomDocuments) ] False


recentDocuments model =
    Widget.menuItemButton "Recent docs" 90 [ paddingTop 12, onClick (DocumentMsg GetRecentDocuments) ] False


searchPublic model =
    Widget.menuItemButton "Public Docs" 90 [ onClick (ChooseSearchType SearchPublic) ] (model.searchDomain == SearchPublic)


searchPrivate model =
    case model.maybeCurrentUser of
        Nothing ->
            empty

        Just _ ->
            searchPrivateAux model


searchPrivateAux model =
    Widget.menuItemButton "My Docs" 90 [ onClick (ChooseSearchType SearchPrivate) ] (model.searchDomain == SearchPrivate)


searchAll model =
    case model.maybeCurrentUser of
        Nothing ->
            empty

        Just _ ->
            searchAllAux model


searchAllAux model =
    Widget.menuItemButton "All Docs" 90 [ onClick (ChooseSearchType SearchAll) ] (model.searchDomain == SearchAll)


testButton2 =
    Widget.menuItemButton "Test" 100 [ onClick (Test) ] False


toggleSearchMenuButton model labelText width msg =
    Widget.menuButton labelText width [ onClick (ToggleSearchMenu msg) ] False
