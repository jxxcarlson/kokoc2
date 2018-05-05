module View.Footer exposing (view)

import Element exposing (image, textLayout, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import Element.Input
import Element.Events exposing (onClick, onInput)
import Element.Keyed
import View.Stylesheet exposing (..)
import Model exposing (Model, Mode(..), Page(..))
import Helper
import View.Widget as Widget
import Msg exposing (Msg(Test))
import Configuration
import Document.Utility
import Document.Model exposing (DocType(..))
import View.DocumentMenu
import User.Action
import Utility


view model =
    Widget.footer model (footerContent model)


footerContent model =
    [ el Menu [ verticalCenter ] (text model.message)
    , wordCount model
    , textLabel <| shareUrl model
    , userStatus model

    -- , textLabel <| "Elapsed: " ++ (toString <| elapsedTime model)
    , documentStatus model

    -- , textLabel <| Configuration.host
    , versionsMenu model
    , View.DocumentMenu.tagsMenuPanel model
    ]


elapsedTime model =
    (model.time - model.startTime) / 1000.0


documentStatus model =
    if model.page == EditorPage then
        documentStatusAux model
    else
        empty


documentStatusAux model =
    case model.currentDocumentNeedsToBeSaved of
        True ->
            Widget.textLabel MenulabelYellow [ paddingXY 24 3 ] "Save document"

        False ->
            Widget.textLabel MenulabelGreen [ paddingXY 24 3 ] "OK"


versionsMenu model =
    if model.maybeCurrentUser /= Nothing && model.page == EditorPage then
        View.DocumentMenu.versionsMenu model
    else
        empty


wordCount model =
    case model.currentDocument.attributes.docType of
        Standard ->
            textLabel <| "Word count: " ++ (toString <| Document.Utility.wordCount model.currentDocument)

        Master ->
            textLabel <| "Word count: " ++ (toString <| Document.Utility.masterDocumenWordCount model)



-- textLabel content =
--     el Menulabel [ paddingLeft 24, verticalCenter ] (text <| content)


userStatus model =
    if model.maybeCurrentUser == Nothing then
        empty
    else
        userStatusAux model


userStatusAux model =
    case User.Action.userFromToken model (Utility.getToken model) of
        Just user ->
            textLabel <| "Signed in as " ++ user.username

        Nothing ->
            Widget.textLabel MenulabelWarning [ paddingXY 8 3 ] "Session expired.  Please sign in again."


textLabel =
    Widget.textLabel Menulabel [ paddingXY 8 3 ]


shareUrl model =
    if model.currentDocument.attributes.public then
        Configuration.client ++ "/#@public/" ++ toString model.currentDocument.id
    else
        ""


testButton =
    Widget.button "Test" 75 [ onClick (Test) ] False
