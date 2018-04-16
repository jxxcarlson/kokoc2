module Model exposing (..)

import Document.Model exposing (Document, SortDirection(..), SortOrder(..), SearchDomain(..))
import User.Model exposing (User)
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
    , counter : Int
    , searchQuery : String
    , sortDirection : SortDirection
    , sortOrder : SortOrder
    , searchDomain : SearchDomain
    , menuAState : MenuState
    }


type alias Flags =
    { width : Int
    , height : Int
    }


type Page
    = StartPage
    | ReaderPage


type Mode
    = Public
    | SigningIn
    | SigningUp
    | SignedIn


type MenuState
    = MenuA MenuStatus


type MenuStatus
    = MenuActive
    | MenuInactive


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
     , counter = 0
     , searchQuery = ""
     , sortDirection = Ascending
     , sortOrder = AlphabeticalOrder
     , searchDomain = SearchAll
     , menuAState = MenuA MenuInactive
     }
    )
