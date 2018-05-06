module View.AdminPage exposing (view)

import Element exposing (image, textLayout, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import Element.Input
import Element.Events exposing (onClick, onInput)
import View.Stylesheet exposing (..)
import Html
import Model exposing (Model, Mode(..))
import Helper
import Msg
import User.Msg
    exposing
        ( UserMsg
            ( UserNoOp
            )
        )
import View.Widget as Widget
import View.Menubar as Menubar
import View.Footer as Footer


--width <| px <| toFloat <| model.windowWidth, height <| px <| toFloat <| model.windowHeight


view model =
    Element.column Main
        [ width fill, height fill ]
        [ Menubar.view model
        , mainRow model
        , Footer.view model
        ]



{- MAIN -}


mainRow model =
    row Main
        [ width fill, height fill ]
        [ column Alternate [ width (fillPortion 30), height fill, paddingXY 40 40 ] (leftColumn model)
        , column Main [ width (fillPortion 70), height fill, center, verticalCenter, spacing 10 ] (mainColumn model)
        ]


displayUser user =
    row Item
        [ spacing 8, height (px 24), width (px 200) ]
        [ textLabel [ width (px 30) ] (toString user.id)
        , textLabel [ width (px 90) ] user.username
        , textLabel [ width (px 130) ] user.name
        , textLabel [ width (px 130) ] user.email
        ]


displayUsers model =
    column Item [ spacing 8, padding 15 ] <| List.map displayUser model.userList


textLabel attributes =
    Widget.textLabel Item ([ verticalCenter ] ++ attributes)


leftColumn model =
    [ row Alternate [] [ Widget.textLabel Heading [ width (px 90) ] "Users" ]
    , row Alternate [ height (px 300), yScrollbar ] [ displayUsers model ]
    ]


mainColumn model =
    [ row Alternate [] [ text <| "Main Column" ]
    ]
