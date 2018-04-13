module Model exposing (..)

import Model.Document exposing (Document)
import Model.User exposing (User)
import Document.Default


type alias Model =
    { mode : Mode
    , page : Page
    , name : String
    , username : String
    , email : String
    , password : String
    , maybeCurrentUser : Maybe User
    , message : String
    , documentList : List Document
    , currentDocument : Document
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



{- USER -}
{- INIT -}


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
     , documentList = []
     , currentDocument = Document.Default.make "TITLE" "CONTENT"
     , windowWidth = flags.width
     , windowHeight = flags.height
     }
    )



{- HELPERS -}


effectiveWindowHeight model =
    toFloat <| model.windowHeight - 160


leftColumnWidth model =
    0.33 * (toFloat <| model.windowWidth)
