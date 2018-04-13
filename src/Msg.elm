module Msg exposing (..)

import Http
import User.Model exposing (User)
import User.Msg exposing (UserMsg)


type Msg
    = NoOpz
    | UserMsg UserMsg
    | Outside InfoForElm
    | LogErr String


type InfoForElm
    = UserLoginInfo User
