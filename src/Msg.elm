module Msg exposing (..)

import Http
import User.Model exposing (User)
import Model exposing (SearchMenuState, VersionsMenuState, DocumentMenuState, SubdocumentPosition, Page(..))
import User.Msg exposing (UserMsg)
import Document.Msg exposing (DocumentMsg)
import Document.Model exposing (SearchDomain(..), TextType(..), DocType(..))


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
    | ChooseSearchType SearchDomain
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


type InfoForElm
    = UserLoginInfo User
    | RenderedText String
