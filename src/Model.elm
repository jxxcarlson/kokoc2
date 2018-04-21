module Model exposing (..)

import Document.Model exposing (Document, SortDirection(..), SortOrder(..), SearchDomain(..))
import User.Model exposing (User)
import Document.Default
import MiniLatex.Differ exposing (EditRecord)
import MiniLatex.Driver


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
    , editRecord : EditRecord
    , masterDocLoaded : Bool
    , masterDocumentId : Int
    , masterDocumentTitle : String
    , windowWidth : Int
    , windowHeight : Int
    , counter : Int
    , searchQuery : String
    , sortDirection : SortDirection
    , sortOrder : SortOrder
    , searchDomain : SearchDomain
    , searchMenuState : SearchMenuState
    , documentMenuState : DocumentMenuState
    , newDocumentPanelState : NewDocumentPanelState
    , documentAttributePanelState : DocumentAttributePanelState
    , newDocumentTitle : String
    , deleteDocumentState : DeleteDocumentState
    , documentTextType : TextType
    }


type alias Flags =
    { width : Int
    , height : Int
    }


type Page
    = StartPage
    | ReaderPage
    | EditorPage


type Mode
    = Public
    | SigningIn
    | SigningUp
    | SignedIn


type TextType
    = MiniLatex
    | Asciidoc


type SearchMenuState
    = SearchMenu MenuStatus


type DocumentMenuState
    = DocumentMenu MenuStatus


type MenuStatus
    = MenuActive
    | MenuInactive


type NewDocumentPanelState
    = NewDocumentPanelActive
    | NewDocumentPanelInactive


type DocumentAttributePanelState
    = DocumentAttributePanelActive
    | DocumentAttributePanelInactive


type DeleteDocumentState
    = DeleteDocumentInactive
    | DeleteDocumentPending


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
     , editRecord = MiniLatex.Driver.setup 0 ""
     , masterDocLoaded = False
     , masterDocumentId = 0
     , masterDocumentTitle = ""
     , windowWidth = flags.width
     , windowHeight = flags.height
     , counter = 0
     , searchQuery = ""
     , sortDirection = Ascending
     , sortOrder = AlphabeticalOrder
     , searchDomain = SearchAll
     , searchMenuState = SearchMenu MenuInactive
     , documentMenuState = DocumentMenu MenuInactive
     , newDocumentPanelState = NewDocumentPanelInactive
     , documentAttributePanelState = DocumentAttributePanelInactive
     , newDocumentTitle = "New Document"
     , deleteDocumentState = DeleteDocumentInactive
     , documentTextType = MiniLatex
     }
    )
