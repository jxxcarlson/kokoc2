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
    | PanelHeading
    | TextPanel
    | Heading
    | LeftHeading
    | Bold
    | Paragraph
    | Title
    | Link
    | InputField
    | Button
    | ButtonSelected
    | FormButton
    | FormButtonSelected
    | SmallButton
    | SmallButtonSelected
    | TOCHeading
    | TOCItem
    | TOCItemSelected
    | None


fontList =
    [ Font.font "Arial"
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
        , style Panel [ Font.typeface fontList, Font.size 16, Color.background Color.darkBlue ]
        , style PanelHeading [ Font.typeface fontList, Font.size 24, Color.background Color.darkBlue, Color.text Color.white ]
        , style TextPanel [ Font.typeface fontList, Color.background (grayColor 245) ]
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
            [ Color.text myBlack
            , Color.background Color.white
            , Font.size 18 -- all units given as px
            , Font.typeface fontList
            ]
        , style Button
            [ Color.text Color.white
            , Color.background (Color.rgb 100 100 100)
            , Border.rounded 8
            , pseudo "active" [ Transition.all, Color.background Color.darkBlue ]
            , Font.size 16 -- all units given as px
            , Font.typeface fontList
            ]
        , style ButtonSelected
            [ Color.text Color.white
            , Color.background (Color.darkBlue)
            , Border.rounded 8
            , pseudo "active" [ Transition.all, Color.background Color.lightBlue ]
            , Font.size 16 -- all units given as px
            , Font.typeface fontList
            ]
        , style FormButton
            [ Color.text myBlack
            , Color.background Color.white
            , Border.rounded 8
            , pseudo "active" [ Transition.all, Color.background Color.darkBlue ]
            , Font.size 16 -- all units given as px
            , Font.typeface fontList
            ]
        , style FormButtonSelected
            [ Color.text myBlack
            , Color.background (Color.lightBlue)
            , Border.rounded 8
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

        , style TOCHeading
            [ Color.text Color.darkBlue
            , Color.background alternateColor 
            , Font.size 16 -- all units given as px
            , Font.typeface fontList
             , Font.weight 800
            ]

        , style TOCItem
            [ Color.text Color.blue
            , Color.background alternateColor 
            , Font.size 12 -- all units given as px
            , Font.typeface fontList
            ]

        , style TOCItemSelected
            [ Color.text Color.blue
            , Color.background alternateColor
            , Font.size 12 -- all units given as px
            , Font.typeface fontList
            , Font.weight 800
            ]
        , style None []
        ]
