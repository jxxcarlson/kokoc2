module Model exposing (..)

import Document.Model
    exposing
        ( Document
        , SortDirection(..)
        , SortOrder(..)
        , SearchDomain(..)
        , TextType(..)
        , DocType(..)
        )
import User.Model exposing (User)
import Document.Default
import MiniLatex.Differ exposing (EditRecord)
import MiniLatex.Driver
import Dict exposing (Dict)
import Html exposing (Html, div, p, ul, li, text)
import Keyboard.Extra exposing (Key(..))
import Time exposing (Time)
import Configuration exposing (TickerState(..))


type alias Model =
    { mode : Mode
    , page : Page
    , name : String
    , username : String
    , email : String
    , password : String
    , maybeCurrentUser : Maybe User
    , message : String
    , errorMessage : String
    , documentList : List Document
    , documentDict : Dict String Document
    , currentDocument : Document
    , currentDocumentNeedsToBeSaved : Bool
    , maybePreviousDocument : Maybe Document
    , editRecord : EditRecord
    , maybeMasterDocument : Maybe Document
    , textToExport : String
    , windowWidth : Int
    , windowHeight : Int
    , counter : Int
    , searchQuery : String
    , sortDirection : SortDirection
    , sortOrder : SortOrder
    , searchDomain : SearchDomain
    , searchMenuState : SearchMenuState
    , documentMenuState : DocumentMenuState
    , versionsMenuState : VersionsMenuState
    , tagsMenuState : TagsMenuState
    , newDocumentPanelState : NewDocumentPanelState
    , documentAttributePanelState : DocumentAttributePanelState
    , newDocumentTitle : String
    , tagString : String
    , newDocumentDocType : DocType
    , deleteDocumentState : DeleteDocumentState
    , documentTextType : TextType
    , documentType : DocType
    , subdocumentPosition : SubdocumentPosition
    , repositoryName : String
    , shareDocumentCommand : String
    , pressedKeys : List Key
    , previousKey : Key
    , time : Time
    , startTime : Time
    , tickerState : TickerState
    }


type alias Flags =
    { width : Int
    , height : Int
    }


type Page
    = StartPage
    | ReaderPage
    | EditorPage
    | UrlPage Int


type Mode
    = Public
    | SigningIn
    | SigningUp
    | SignedIn


type SearchMenuState
    = SearchMenu MenuStatus


type DocumentMenuState
    = DocumentMenu MenuStatus


type VersionsMenuState
    = VersionsMenu MenuStatus


type TagsMenuState
    = TagsMenu MenuStatus


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


type SubdocumentPosition
    = SubdocumentAtTop
    | SubdocumentAtBottom
    | SubdocumentAboveCurrent
    | SubdocumentBelowCurrent
    | DoNotAttachSubdocument


initialModel : Flags -> Model
initialModel flags =
    ({ mode = Public
     , page = StartPage
     , name = ""
     , username = ""
     , email = ""
     , password = ""
     , maybeCurrentUser = Nothing
     , message = ""
     , errorMessage = ""
     , documentList = []
     , documentDict = Dict.empty
     , currentDocument = Document.Default.make "TITLE" "CONTENT"
     , currentDocumentNeedsToBeSaved = False
     , maybePreviousDocument = Nothing
     , editRecord = MiniLatex.Driver.setup 0 ""
     , maybeMasterDocument = Nothing
     , textToExport = ""
     , windowWidth = flags.width
     , windowHeight = flags.height
     , counter = 0
     , searchQuery = ""
     , sortDirection = Ascending
     , sortOrder = AlphabeticalOrder
     , searchDomain = SearchPublic
     , searchMenuState = SearchMenu MenuInactive
     , documentMenuState = DocumentMenu MenuInactive
     , versionsMenuState = VersionsMenu MenuInactive
     , tagsMenuState = TagsMenu MenuInactive
     , newDocumentPanelState = NewDocumentPanelInactive
     , documentAttributePanelState = DocumentAttributePanelInactive
     , newDocumentTitle = "New Document"
     , tagString = ""
     , newDocumentDocType = Standard
     , deleteDocumentState = DeleteDocumentInactive
     , documentTextType = MiniLatex
     , documentType = Standard
     , subdocumentPosition = DoNotAttachSubdocument
     , repositoryName = "default"
     , shareDocumentCommand = "username: rw"
     , pressedKeys = []
     , previousKey = F24
     , time = 0
     , startTime = 0
     , tickerState = Configuration.initialTickerState
     }
    )
