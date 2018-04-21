module Msg exposing (..)

import Http
import User.Model exposing (User)
import Model exposing (SearchMenuState, DocumentMenuState)
import User.Msg exposing (UserMsg)
import Document.Msg exposing (DocumentMsg)
import Document.Model exposing (SearchDomain(..))


type Msg
    = NoOpz
    | UserMsg UserMsg
    | DocumentMsg DocumentMsg
    | Outside InfoForElm
    | LogErr String
    | GotoStartPage
    | GotoReaderPage
    | GotoEditorPage
    | Test
    | ToggleDocumentMenu DocumentMenuState
    | ToggleSearchMenu SearchMenuState
    | ChooseSearchType SearchDomain
    | CloseMenus
    | DisplayNewDocumentPanel
    | CancelNewDocument
    | InputNewDocumentTitle String


type InfoForElm
    = UserLoginInfo User
    | RenderedText String
