module View.AdminPage exposing (view)

import Element exposing (image, textLayout, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import Element.Input
import Element.Events exposing (onClick, onInput)
import View.Stylesheet exposing (..)
import Html
import Model exposing (Model, Mode(..))
import Helper
import Msg exposing (Msg)
import User.Msg
    exposing
        ( UserMsg
            ( UserNoOp
            , DeleteUser
            )
        )
import View.Widget as Widget
import View.Menubar as Menubar
import View.Footer as Footer
import View.Widget as Widget


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
        [ column Alternate [ width (fillPortion 40), height fill, paddingXY 40 40 ] (leftColumn model)
        , column Main [ width (fillPortion 60), height fill, center, verticalCenter, spacing 10 ] (mainColumn model)
        ]


displayUser user =
    row Item
        [ spacing 8, height (px 24), width (px 200) ]
        [ textLabel [ width (px 30) ] (toString user.id)
        , textLabel [ width (px 90) ] user.username
        , textLabel [ width (px 130) ] user.name
        , textLabel [ width (px 130) ] user.email

        -- , deleteUserButton user
        ]


deleteUserButton user =
    Widget.bareButton2 SmallButton "Delete" 30 [ height (px 25), width (px 50), onClick ((Msg.UserMsg << DeleteUser) user.id) ]


displayUsers model =
    column Item [ spacing 8, padding 15, height <| userDisplayHeight model ] <| List.map displayUser model.userList


userDisplayHeight model =
    model.windowHeight - 180 |> toFloat |> px


textLabel attributes =
    Widget.textLabel Item ([ verticalCenter ] ++ attributes)


leftColumn model =
    [ row Alternate [] [ Widget.textLabel LeftHeading [ width (px 90) ] ("Users: " ++ (toString (List.length model.userList))) ]
    , row Alternate [ height <| userDisplayHeight model, yScrollbar ] [ displayUsers model ]
    ]


mainColumn model =
    [ row Alternate [] [ text <| "Main Column" ]
    ]
