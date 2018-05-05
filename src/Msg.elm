module Msg exposing (..)

import Http
import User.Model exposing (User)
import Model
    exposing
        ( SearchMenuState
        , VersionsMenuState
        , DocumentMenuState
        , TagsMenuState
        , SubdocumentPosition
        , Page(..)
        )
import User.Msg exposing (UserMsg)
import Document.Msg exposing (DocumentMsg)
import Document.Model exposing (SearchDomain(..), SortOrder(..), TextType(..), DocType(..))
import Keyboard.Extra
import Time exposing (Time)


type Msg
    = NoOpz
    | UserMsg UserMsg
    | DocumentMsg DocumentMsg
    | Outside InfoForElm
    | LogErr String
    | GotoStartPage
    | GotoReaderPage
    | GotoEditorPage
    | GotoHomePage
    | Test
    | ToggleDocumentMenu DocumentMenuState
    | ToggleSearchMenu SearchMenuState
    | ToggleVersionsMenu VersionsMenuState
    | ToggleTagsMenu TagsMenuState
    | ChooseSearchType SearchDomain
    | ChooseSortOrder SortOrder
    | CloseMenus
    | DisplayNewDocumentPanel
    | DisplayDocumentAttributesPanel
    | CancelNewDocument
    | InputNewDocumentTitle String
    | InputRepositoryName String
    | InputShareDocumentCommand String
    | SetDocumentTextType TextType
    | SetDocumentType DocType
    | SetSubdocumentPosition SubdocumentPosition
    | GoToPage (Maybe Page)
    | KeyboardMsg Keyboard.Extra.Msg
    | Tick Time
    | RequestTime
    | ReceiveTime Time
    | RequestStartTime
    | ReceiveStartTime Time


type InfoForElm
    = UserLoginInfo User
    | RenderedText String
