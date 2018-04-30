module View.MenuManager
    exposing
        ( toggleSearchMenu
        , toggleDocumentsMenu
        , toggleVersionsMenu
        , closeMenus
        , displayNewDocumentsPanel
        , cancelNewDocument
        )

import Msg exposing (Msg)
import Model
    exposing
        ( Model
        , DocumentMenuState(..)
        , MenuStatus(..)
        , SearchMenuState(..)
        , DeleteDocumentState(..)
        , DocumentAttributePanelState(..)
        , NewDocumentPanelState(..)
        , VersionsMenuState(..)
        )
import Document.Model exposing (DocType(..))


toggleSearchMenu : Model -> SearchMenuState -> ( Model, Cmd Msg )
toggleSearchMenu model menu =
    let
        searchMenuState =
            case menu of
                SearchMenu MenuInactive ->
                    SearchMenu MenuActive

                SearchMenu MenuActive ->
                    SearchMenu MenuInactive
    in
        ( { model | documentMenuState = DocumentMenu MenuInactive, searchMenuState = searchMenuState }, Cmd.none )


toggleDocumentsMenu : Model -> DocumentMenuState -> ( Model, Cmd Msg )
toggleDocumentsMenu model menu =
    let
        documentMenuState =
            case menu of
                DocumentMenu MenuInactive ->
                    DocumentMenu MenuActive

                DocumentMenu MenuActive ->
                    DocumentMenu MenuInactive
    in
        ( { model
            | searchMenuState = SearchMenu MenuInactive
            , documentMenuState = documentMenuState
            , deleteDocumentState = DeleteDocumentInactive
          }
        , Cmd.none
        )


toggleVersionsMenu : Model -> VersionsMenuState -> ( Model, Cmd Msg )
toggleVersionsMenu model menu =
    let
        versionsMenuState =
            case menu of
                VersionsMenu MenuInactive ->
                    VersionsMenu MenuActive

                VersionsMenu MenuActive ->
                    VersionsMenu MenuInactive
    in
        ( { model | versionsMenuState = versionsMenuState }, Cmd.none )


closeMenus : Model -> ( Model, Cmd Msg )
closeMenus model =
    ( { model
        | searchMenuState = SearchMenu MenuInactive
        , documentMenuState = DocumentMenu MenuInactive
        , deleteDocumentState = DeleteDocumentInactive
        , documentAttributePanelState = DocumentAttributePanelInactive
        , newDocumentPanelState = NewDocumentPanelInactive
        , versionsMenuState = VersionsMenu MenuInactive
      }
    , Cmd.none
    )


displayNewDocumentsPanel : Model -> ( Model, Cmd Msg )
displayNewDocumentsPanel model =
    ( { model
        | newDocumentPanelState = NewDocumentPanelActive
        , documentType = Standard
      }
    , Cmd.none
    )


displayAttributesPanel : Model -> ( Model, Cmd Msg )
displayAttributesPanel model =
    ( { model
        | documentAttributePanelState = DocumentAttributePanelActive
        , documentType = model.currentDocument.attributes.docType
        , documentTextType = model.currentDocument.attributes.textType
      }
    , Cmd.none
    )


cancelNewDocument model =
    ( { model
        | newDocumentPanelState = NewDocumentPanelInactive
        , documentMenuState = DocumentMenu MenuInactive
      }
    , Cmd.none
    )
