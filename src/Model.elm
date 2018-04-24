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
    , maybeMasterDocument : Maybe Document
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
    , newDocumentDocType : DocType
    , deleteDocumentState : DeleteDocumentState
    , documentTextType : TextType
    , documentType : DocType
    , subdocumentPosition : SubdocumentPosition
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
     , message = "App started"
     , documentList = []
     , currentDocument = Document.Default.make "TITLE" "CONTENT"
     , editRecord = MiniLatex.Driver.setup 0 ""
     , masterDocLoaded = False
     , masterDocumentId = 0
     , masterDocumentTitle = ""
     , maybeMasterDocument = Nothing
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
     , newDocumentDocType = Standard
     , deleteDocumentState = DeleteDocumentInactive
     , documentTextType = MiniLatex
     , documentType = Standard
     , subdocumentPosition = DoNotAttachSubdocument
     }
    )
