module User.Action
    exposing
        ( handleToken
        , handleUserRecord
        , userFromToken
        , getUser
        , getUserList
        , getUserListCommmand
        , userIdFromToken
        , reconnectUser
        , setMode
        , signOutCommand
        , deleteUserCmd
        )

import Json.Encode as Encode
import Jwt exposing (decodeToken)


--

import Model exposing (Model, Mode(..))
import Msg exposing (Msg)


--

import User.Model exposing (User, UserListRecord)
import User.Data as Data
import User.RequestParameters
import User.Mail
import User.Model exposing (UserRecord)


--

import Api.Request
import OutsideInfo exposing (InfoForOutside(..))
import Document.Model exposing (SearchDomain(..))


handleToken : Model -> String -> ( Model, Cmd Msg )
handleToken model token =
    let
        newModel =
            modelFromToken model token

        userId =
            (case newModel.maybeCurrentUser of
                Just user ->
                    user.id

                Nothing ->
                    0
            )
    in
        ( newModel
        , Cmd.batch
            [ sendUserDataToLocalStorage newModel
            , Api.Request.doRequest <| User.RequestParameters.getUser userId
            ]
        )


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
                Just <| User "" id username model.email "" token False True

        Err error ->
            Nothing


userIdFromToken : String -> Int
userIdFromToken token =
    case Jwt.decodeToken Data.jwtDecoder token of
        Ok value ->
            value.user_id

        Err error ->
            0


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
            userRecord.user
    in
        case Jwt.decodeToken Data.userRecordDecoder user.token of
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


getUserCommmand : Int -> Cmd Msg
getUserCommmand userId =
    Api.Request.doRequest <| User.RequestParameters.getUser userId


getUserListCommmand : Cmd Msg
getUserListCommmand =
    Api.Request.doRequest <| User.RequestParameters.getUserList


deleteUserCmd : String -> Int -> Cmd Msg
deleteUserCmd token userId =
    Api.Request.doRequest <| User.RequestParameters.deleteUser token userId


getUser : Model -> UserRecord -> ( Model, Cmd Msg )
getUser model userRecord =
    let
        completeUser =
            userRecord.user

        maybeCurrentUser =
            (case model.maybeCurrentUser of
                Just user ->
                    Just
                        { user
                            | blurb = completeUser.blurb
                            , admin = completeUser.admin
                            , name = completeUser.name
                        }

                Nothing ->
                    Nothing
            )
    in
        ( { model | maybeCurrentUser = maybeCurrentUser }, Cmd.none )


getUserList : Model -> UserListRecord -> ( Model, Cmd Msg )
getUserList model userListRecord =
    ( { model | userList = userListRecord.users }, Cmd.none )
