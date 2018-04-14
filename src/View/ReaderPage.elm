module View.ReaderPage exposing (view)

import Element exposing (image, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import Element.Input
import Element.Events exposing (onClick, onInput)
import Element.Keyed
import View.Stylesheet exposing (..)
import Model exposing (Model)
import View.Widget as Widget
import View.Menubar as Menubar
import View.Footer as Footer


view model =
    Element.column Main
        [ width <| px <| toFloat <| model.windowWidth, height <| px <| toFloat <| model.windowHeight ]
        [ Menubar.view model
        , mainRow model
        , Footer.view model
        ]



-- inputField label_ value_ width_ action


mainRow model =
    row Main
        [ height fill ]
        [ column Alternate [ width (fillPortion 30), height fill ] [ text "TOC" ]
        , column Main [ width (fillPortion 70), height fill ] [ text "READER IN PAGE" ]
        ]


menuContent =
    [ el Menubar [ verticalCenter, paddingLeft 20, paddingRight 20 ] (text "Sign in Menubar")
    ]


footerContent =
    [ el Menubar [ verticalCenter, paddingLeft 20, paddingRight 20 ] (text "Sign in Footer")
    ]
