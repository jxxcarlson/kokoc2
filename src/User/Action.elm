module User.Action exposing (..)

import Jwt exposing (decodeToken)
import Model exposing (Model, Mode(..))
import User.Model exposing (User)
import User.Data as Data
import Json.Encode as Encode
import Msg exposing (Msg)
import User.Model exposing (UserRecord)
import OutsideInfo exposing (InfoForOutside(..))
import Document.Model exposing (SearchDomain(..))


handleToken model token =
    let
        newModel =
            modelFromToken model token
    in
        ( newModel, sendUserDataToLocalStorage newModel )


userFromToken : Model -> String -> Maybe User
userFromToken model token =
    case Jwt.decodeToken Data.jwtDecoder token of
        Ok value ->
            let
                username =
                    value.username

                id =
                    value.user_id
            in
                Just <| User "" id username model.email "" token False

        Err error ->
            Nothing


modelFromToken : Model -> String -> Model
modelFromToken model token =
    let
        maybeUser =
            userFromToken model token

        mode =
            case maybeUser of
                Nothing ->
                    Public

                Just user ->
                    SignedIn
    in
        { model | maybeCurrentUser = maybeUser, searchDomain = SearchPrivate, mode = mode, password = "" }


handleUserRecord : Model -> UserRecord -> ( Model, Cmd Msg )
handleUserRecord model userRecord =
    let
        user =
            Debug.log "handleUserRecord"
                userRecord.user
    in
        case Jwt.decodeToken Data.jwtDecoder user.token of
            Ok value ->
                let
                    newModel =
                        { model | maybeCurrentUser = Just user, mode = SignedIn, password = "" }
                in
                    ( newModel, sendUserDataToLocalStorage newModel )

            Err error ->
                ( { model | maybeCurrentUser = Nothing, mode = Public, password = "", message = "Error !!!" }, Cmd.none )


sendUserDataToLocalStorage : Model -> Cmd Msg
sendUserDataToLocalStorage model =
    case model.maybeCurrentUser of
        Nothing ->
            Cmd.none

        Just user ->
            OutsideInfo.sendInfoOutside (UserData <| Data.encodeUserData user)


reconnectUser : Model -> User -> Model
reconnectUser model user =
    { model | maybeCurrentUser = Just user, mode = SignedIn }


setMode : Model -> Mode
setMode model =
    case model.mode of
        Public ->
            SigningIn

        SigningIn ->
            SigningIn

        SigningUp ->
            SigningUp

        SignedIn ->
            Public


signOutCommand : Model -> Cmd Msg
signOutCommand model =
    if model.mode == SignedIn then
        OutsideInfo.sendInfoOutside (DisconnectUser Encode.null)
    else
        Cmd.none
