module User.Action exposing (..)

import Jwt exposing (decodeToken)
import Model exposing (Model, Mode(..))
import User.Data as Data
import Msg exposing (UserRecord, Msg, User)


handleToken model token =
    ( modelFromToken model token, Cmd.none )


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
        { model | maybeCurrentUser = maybeUser, mode = mode, password = "" }


handleUserRecord : Model -> UserRecord -> ( Model, Cmd Msg )
handleUserRecord model userRecord =
    let
        user =
            Debug.log "hamdleUserRecord"
                userRecord.user
    in
        case Jwt.decodeToken Data.jwtDecoder user.token of
            Ok value ->
                ( { model | maybeCurrentUser = Just user, mode = SignedIn, password = "" }, Cmd.none )

            Err error ->
                ( { model | maybeCurrentUser = Just user, mode = Public, password = "" }, Cmd.none )
