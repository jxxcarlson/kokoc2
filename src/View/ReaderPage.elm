module View.ReaderPage exposing (view)

import Element exposing (image, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import View.Stylesheet exposing (..)
import Model exposing (Model)
import Msg exposing(Msg)
import Document.Model exposing(Document)
import View.Menubar as Menubar
import View.Footer as Footer
import View.TOC as TOC

view : Model -> (Element.Element MyStyles variation Msg)
view model =
    Element.column Main
        [ width <| px <| toFloat <| model.windowWidth, height <| px <| toFloat <| model.windowHeight ]
        [ Menubar.view model
         , row Main [spacing 20, height fill] [tableOfContents model, mainContent model]
        , Footer.view model
        ]


mainContent model = 
   column Main [ height fill, paddingXY 20 20, center, verticalCenter] [text "MAIN CONTENT"]


tableOfContents : Model -> Element.Element MyStyles variation Msg
tableOfContents model =
    row Alternate
        [ height fill, paddingXY 20 20 ] 
           (innerTableOfContents model.currentDocument model.documentList)
    


innerTableOfContents : Document -> List Document -> List (Element.Element MyStyles variation Msg)
innerTableOfContents activeDocument documentList =
  [ column Main [ ] [
          row Alternate [] [text "Documents"]
        , column Alternate [ width (fillPortion 30), height fill ] ( TOC.view 100 activeDocument documentList )
        ]
  ]

{- MENU -}


menuContent : List (Element.Element MyStyles variation msg)
menuContent =
    [ el Menubar [ verticalCenter, paddingLeft 20, paddingRight 20 ] (text "Sign in Menubar")
    ]

footerContent : List (Element.Element MyStyles variation msg)
footerContent =
    [ el Menubar [ verticalCenter, paddingLeft 20, paddingRight 20 ] (text "Sign in Footer")
    ]
