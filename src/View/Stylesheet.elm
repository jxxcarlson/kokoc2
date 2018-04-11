module View.Stylesheet exposing (..)

import Style exposing (style, pseudo)
import Color
import Style.Color as Color
import Style.Font as Font
import Style.Transition as Transition
import Style.Border as Border


type MyStyles
    = Main
    | Menubar
    | Alternate
    | Panel
    | TextPanel
    | Heading
    | LeftHeading
    | RightColumnHeading
    | Bold
    | Paragraph
    | Title
    | Link
    | InputField
    | Button
    | ButtonSelected
    | SmallButton
    | SmallButtonSelected
    | RowLabel
    | None


fontList =
    [ Font.font "Georgia"
    ]


mainColor =
    Color.rgb 220 220 230


alternateColor =
    Color.rgb 200 200 210


grayColor x =
    Color.rgb x x x


myBlack =
    grayColor 60


stylesheet =
    Style.styleSheet
        [ style Main [ Color.background mainColor ]
        , style Menubar [ Color.background <| grayColor 40, Color.text Color.white ]
        , style Alternate [ Color.background alternateColor ]
        , style Panel [ Font.size 14, Color.background (Color.rgba 250 250 250 1.0) ]
        , style TextPanel [ Color.background (grayColor 245) ]
        , style Title
            [ Color.text Color.black
            , Color.background mainColor
            , Font.size 35 -- all units given as px
            , Font.typeface fontList
            ]
        , style Heading
            [ Color.text myBlack
            , Color.background mainColor
            , Font.size 24 -- all units given as px
            , Font.typeface fontList
            , Font.weight 600
            ]
        , style LeftHeading
            [ Color.text myBlack
            , Color.background alternateColor
            , Font.size 18 -- all units given as px
            , Font.typeface fontList
            , Font.weight 600
            ]
        , style Bold
            [ Color.text Color.black
            , Color.background mainColor
            , Font.size 18 -- all units given as px
            , Font.typeface fontList
            , Font.weight 550
            ]
        , style Paragraph
            [ Color.text Color.black
            , Color.background mainColor
            , Font.size 18 -- all units given as px
            , Font.typeface fontList
            ]
        , style InputField
            [ Color.text Color.white
            , Color.background (grayColor 160)
            , Font.size 18 -- all units given as px
            , Font.typeface fontList
            ]
        , style RowLabel
            [ Color.text Color.white
            , Color.background Color.darkBlue
            , Font.size 18 -- all units given as px
            , Font.typeface fontList
            ]
        , style Button
            [ Color.text Color.white
            , Color.background (Color.rgb 100 100 100)
            , pseudo "active" [ Transition.all, Color.background Color.darkBlue ]
            , Font.size 16 -- all units given as px
            , Font.typeface fontList
            ]
        , style ButtonSelected
            [ Color.text Color.white
            , Color.background (Color.darkBlue)
            , pseudo "active" [ Transition.all, Color.background Color.lightBlue ]
            , Font.size 16 -- all units given as px
            , Font.typeface fontList
            ]
        , style SmallButton
            [ Color.text Color.white
            , Color.background (Color.rgb 150 150 250)
            , Border.rounded 4
            , pseudo "active" [ Transition.all, Color.background (Color.rgb 0 0 255) ]
            , Font.size 11 -- all units given as px
            , Font.typeface fontList
            ]
        , style SmallButtonSelected
            [ Color.text Color.white
            , Color.background (Color.red)
            , Border.rounded 8
            , pseudo "active" [ Transition.all, Color.background Color.darkBlue ]
            , Font.size 12 -- all units given as px
            , Font.typeface fontList
            ]
        , style Link
            [ Color.text Color.lightGray
            , Color.background Color.darkBlue
            , Font.size 16 -- all units given as px
            , Font.typeface fontList
            ]
        , style None []
        ]
