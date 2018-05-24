module User.Update exposing (..)

import Model exposing (Model, Flags, initialModel, Mode(..), Page(..))
import Msg exposing (Msg)
import User.Msg exposing (..)
import Api.Request as Request
import User.RequestParameters as RequestParameters
import User.Action
import Utility


update : UserMsg -> Model -> ( Model, Cmd Msg )
update submessage model =
    case submessage of
        SignIn ->
            ( { model
                | mode = User.Action.setMode model
                , page = StartPage
                , maybeCurrentUser = Nothing
              }
            , User.Action.signOutCommand model
            )

        AuthenticateUser ->
            ( model, Request.doRequest <| RequestParameters.authenticateUser model.email model.password )

        VerifyAuthentication (Ok token) ->
            User.Action.handleToken model token

        VerifyAuthentication (Err error) ->
            ( { model | errorMessage = (toString error) }, Cmd.none )

        SignUpUser ->
            ( model, Request.doRequest <| RequestParameters.signUpUser model )

        VerifySignUp (Ok userRecord) ->
            User.Action.handleUserRecord model userRecord

        VerifySignUp (Err error) ->
            ( { model | errorMessage = (toString error) }, Cmd.none )

        GetUser (Ok userRecord) ->
            User.Action.getUser model userRecord

        GetUser (Err error) ->
            ( { model | errorMessage = (toString error) }, Cmd.none )

        GetUserList (Ok userListRecord) ->
            User.Action.getUserList model userListRecord

        GetUserList (Err error) ->
            ( { model | errorMessage = (toString error) }, Cmd.none )

        DeleteUser userId ->
            ( { model | message = "Delete user " ++ (toString userId) }
            , User.Action.deleteUserCmd (Utility.getToken model) userId
            )

        ProcessDeletedDocument (Ok result) ->
            ( { model | message = result.reply }, Cmd.none )

        ProcessDeletedDocument (Err error) ->
            ( { model | message = "Error: could not delete user", errorMessage = (toString error) }, Cmd.none )

        CancelSignIn ->
            ( { model | mode = Public }, Cmd.none )

        GoToSignupForm ->
            ( { model | mode = SigningUp }, Cmd.none )

        InputName str ->
            ( { model | name = str }, Cmd.none )

        InputUsername str ->
            ( { model | username = str }, Cmd.none )

        InputEmail str ->
            ( { model | email = str }, Cmd.none )

        InputPassword str ->
            ( { model | password = str }, Cmd.none )

        UserNoOp ->
            ( model, Cmd.none )
