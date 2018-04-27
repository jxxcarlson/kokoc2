module Nav.Parser exposing (urlParser)

import Nav.UrlParser as UrlParser exposing (parseHash2, (</>), int, oneOf, Parser)
import Navigation exposing (..)
import Model exposing (Page(..))
import Msg exposing (Msg(GoToPage))


route : Parser (Page -> a) a
route =
    oneOf
        [ -- UrlParser.map ReaderPage (UrlParser.s "home")
          UrlParser.map UrlPage (UrlParser.s "document" </> int)
        , UrlParser.map UrlPage (UrlParser.s "public" </> int)
        ]


urlParser : Location -> Msg
urlParser location =
    parseHash2 route location
        |> GoToPage
