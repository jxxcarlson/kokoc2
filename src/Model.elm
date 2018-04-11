module Model exposing (..)

import Msg exposing (..)


type alias Model =
    { mode : Mode
    , page : Page
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


initialModel : Flags -> Model
initialModel flags =
    ({ mode = Public
     , page = StartPage
     , message = "App started"
     , windowWidth = flags.width
     , windowHeight = flags.height
     }
    )
