module View.StartPage exposing (view)

import Element exposing (image, textLayout, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import Element.Input
import Element.Events exposing (onClick, onInput)
import Element.Keyed
import View.Stylesheet exposing (..)
import Model exposing (Model, effectiveWindowHeight)
import View.Widget as Widget
import View.Text as Text


view model =
    Element.column Main
        [ width <| px <| toFloat <| model.windowWidth, height <| px <| toFloat <| model.windowHeight ]
        [ Widget.menubar model menuContent
        , mainRow model
        , Widget.footer model footerContent
        ]



{- MAIN -}


mainRow model =
    row Main
        [ height fill ]
        [ column Alternate [ width (fillPortion 30), height fill, paddingTop 30, spacing 15 ] (leftColumn model)
        , column Main [ width (fillPortion 70), height fill, center, verticalCenter, spacing 40 ] (mainContent model)
        ]



{- LEFT COLUMN -}


leftColumn model =
    [ row LeftHeading [ paddingLeft 40 ] [ text ("About kNode") ]
    , row Alternate [ paddingLeft 40 ] [ textLayout Alternate [ yScrollbar, height (px <| effectiveWindowHeight model), width (px 300), spacing 10 ] textContent ]
    ]


textContent =
    Text.loremIpsum |> Text.paragraphify (\x -> paragraph Alternate [ width (px 300) ] [ text x ])



{- MAIN COLUMN -}


mainContent model =
    [ row Heading [ center ] [ text ("kNode: A place to share your knowledge") ]
    , row Main [ center ] [ mainImage ]
    ]


mainImage =
    image Main [ width (percent 80) ] { src = "https://www.ibiblio.org/wm/paint/auth/kandinsky/kandinsky.comp-8.jpg", caption = "Kandinsky" }



{- MENU -}


menuContent =
    [ leftMenu, centerMenu, rightMenu ]


leftMenu =
    row Menubar [ alignLeft, width (fillPortion 33), paddingLeft 20 ] [ el Menubar [ verticalCenter, paddingLeft 20, paddingRight 20 ] (text "Yo!  ") ]


centerMenu =
    row Menubar [ center, width (fillPortion 35) ] [ el Menubar [ verticalCenter, paddingLeft 20, paddingRight 20 ] (text "Welcome!  ") ]


rightMenu =
    row Menubar [ alignRight, width (fillPortion 33), paddingRight 20 ] [ Widget.button "Sign in" 75 [] False ]



{- FOOTER -}


footerContent =
    [ el Menubar [ verticalCenter, paddingLeft 20, paddingRight 20 ] (text "Start Page Footer")
    ]
