module Model exposing (..)

import Msg exposing (..)


type alias Model =
    { mode : Mode
    , page : Page
    , name : String
    , username : String
    , email : String
    , password : String
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
    | SigningIn
    | SigningUp
    | SignedIn


effectiveWindowHeight model =
    toFloat <| model.windowHeight - 160


leftColumnWidth model =
    0.33 * (toFloat <| model.windowWidth)


initialModel : Flags -> Model
initialModel flags =
    ({ mode = Public
     , page = StartPage
     , name = ""
     , username = ""
     , email = ""
     , password = ""
     , maybeCurrentUser = Nothing
     , message = "App started"
     , windowWidth = flags.width
     , windowHeight = flags.height
     }
    )
