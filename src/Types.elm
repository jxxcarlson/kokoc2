module Types exposing (..)

import Http exposing (get, send)
import Http


type alias Model =
    { message : String
    , windowWidth : Int
    , windowHeight : Int
    }


type Msg
    = NoOp
    | Input String
    | ReverseText
