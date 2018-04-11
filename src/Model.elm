module Model exposing (..)

import Msg exposing (..)
import User.Main exposing (User)


type alias Model =
    { mode : Mode
    , page : Page
    , maybeCurrentUser : Maybe User
    , message : String
    , windowWidth : Int
    , windowHeight : Int
    }


type alias Flags =
    { width : Int
    , height : Int
    }


type Page
    = StartPage
    | SigninPage


type Mode
    = Public
    | SignedIn


effectiveWindowHeight model =
    toFloat <| model.windowHeight - 160


initialModel : Flags -> Model
initialModel flags =
    ({ mode = Public
     , page = StartPage
     , maybeCurrentUser = Nothing
     , message = "App started"
     , windowWidth = flags.width
     , windowHeight = flags.height
     }
    )
