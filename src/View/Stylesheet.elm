module View.Stylesheet exposing (..)

import Style exposing (style, pseudo)
import Color
import Style.Color as Color
import Style.Font as Font
import Style.Transition as Transition
import Style.Border as Border


type MyStyles
    = Main
    | MainContent
    | Menubar
    | Menu
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
    | MenuButton
    | MenuButtonSelected
    | FormButton
    | FormButtonSelected
    | SmallButton
    | SmallButtonSelected
    | TOCHeading
    | TOCItem
    | TOCItemSelected
    | TOCItemNotLoaded
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


menubarColor =
    grayColor 40


menuColor =
    grayColor 70


stylesheet =
    Style.styleSheet
        [ style Main [ Color.background mainColor ]
        , style Menubar [ Color.background <| menubarColor, Color.text Color.white ]
        , style Menu [ Color.background <| menuColor, Color.text Color.white ]
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
        , style MenuButton
            [ Color.text Color.white
            , Color.background menuColor
            , pseudo "active" [ Transition.all, Color.background Color.darkBlue ]
            , Font.size 16 -- all units given as px
            , Font.typeface fontList
            ]
        , style MenuButtonSelected
            [ Color.text Color.white
            , Color.background (Color.darkBlue)
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
            [ Color.text Color.darkBlue
            , Color.background alternateColor
            , Font.size 12 -- all units given as px
            , Font.typeface fontList
            , Font.weight 800
            ]
        , style TOCItemNotLoaded
            [ Color.text Color.lightCharcoal
            , Color.background alternateColor
            , Font.size 12 -- all units given as px
            , Font.typeface fontList
            , Font.weight 800
            ]
        , style MainContent [ Color.background Color.white ]
        , style None []
        ]
