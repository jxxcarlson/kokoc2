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
    , textLabel <| "Time: " ++ (toString model.time)

    -- , textLabel <| Configuration.host
    , versionsMenu model
    ]


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
    case User.Action.userFromToken model (Utility.getToken model) of
        Just user ->
            textLabel <| "Signed in as " ++ user.username

        Nothing ->
            Widget.textLabel 24 MenulabelWarning "Session expired.  Please sign in again."


textLabel =
    Widget.textLabel 24 Menulabel


shareUrl model =
    if model.currentDocument.attributes.public then
        Configuration.client ++ "/#@public/" ++ toString model.currentDocument.id
    else
        ""


testButton =
    Widget.button "Test" 75 [ onClick (Test) ] False
