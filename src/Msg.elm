module Msg exposing (..)

import Http
import User.Model exposing (User)
import User.Msg exposing (UserMsg)
import Document.Msg exposing (DocumentMsg)


type Msg
    = NoOpz
    | UserMsg UserMsg
    | DocumentMsg DocumentMsg
    | Outside InfoForElm
    | LogErr String
    | GotoStartPage
    | GotoReaderPage


type InfoForElm
    = UserLoginInfo User
