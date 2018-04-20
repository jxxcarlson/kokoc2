module View.SearchMenu exposing (view)

import Element exposing(..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick, onInput)
import View.Stylesheet exposing (..)
import Model exposing (Model, Mode(..), Page(..), SearchMenuState(..), DocumentMenuState(..), MenuStatus(..))
import View.Widget as Widget
import Msg exposing (..)
import Document.Model exposing (Document, SearchDomain(..))
import Model exposing (Model, Page(..))


view model =
    case model.searchMenuState of
        SearchMenu MenuInactive ->
            column Menu
                [ width (px 110), height (px 200), spacing 15, paddingTop 4 ]
                [ toggleSearchMenuButton model "Search" 60 (SearchMenu MenuInactive) ]

        SearchMenu MenuActive ->
            screen <|
                column Menu
                    [ moveRight 200, width (px 110), height (px 200), paddingTop 8, paddingLeft 15, paddingTop 4 ]
                    [ (toggleSearchMenuButton model "Search" 60 (SearchMenu MenuActive))
                    , searchPublic model
                    , searchPrivate model
                    , searchAll model
                    , (toggleSearchMenuButton model "X" 50 (SearchMenu MenuActive))
                    ]


searchPublic model =
    Widget.menuButton "Public Docs" 90 [ onClick (ChooseSearchType SearchPublic) ] (model.searchDomain == SearchPublic)


searchPrivate model =
    Widget.menuButton "My Docs" 90 [ onClick (ChooseSearchType SearchPrivate) ] (model.searchDomain == SearchPrivate)


searchAll model =
    Widget.menuButton "All Docs" 90 [ onClick (ChooseSearchType SearchAll) ] (model.searchDomain == SearchAll)


testButton2 =
    Widget.menuButton "Test" 100 [ onClick (Test) ] False


toggleSearchMenuButton model labelText width msg =
    Widget.menuButton labelText width [ onClick (ToggleSearchMenu msg) ] False
