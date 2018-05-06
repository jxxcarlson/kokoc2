module User.Update exposing (..)

import Model exposing (Model, Flags, initialModel, Mode(..), Page(..))
import Msg exposing (Msg)
import User.Msg exposing (..)
import Api.Request as Request
import User.RequestParameters as RequestParameters
import User.Action as Action


update : UserMsg -> Model -> ( Model, Cmd Msg )
update submessage model =
    case submessage of
        SignIn ->
            ( { model
                | mode = Action.setMode model
                , page = StartPage
                , maybeCurrentUser = Nothing
              }
            , Action.signOutCommand model
            )

        AuthenticateUser ->
            ( model, Request.doRequest <| RequestParameters.authenticateUser model )

        VerifyAuthentication (Ok token) ->
            Action.handleToken model token

        VerifyAuthentication (Err error) ->
            ( { model | errorMessage = (toString error) }, Cmd.none )

        SignUpUser ->
            ( model, Request.doRequest <| RequestParameters.signUpUser model )

        VerifySignUp (Ok userRecord) ->
            Action.handleUserRecord model userRecord

        VerifySignUp (Err error) ->
            ( { model | errorMessage = (toString error) }, Cmd.none )

        GetUser (Ok userRecord) ->
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

        GetUser (Err error) ->
            ( { model | errorMessage = (toString error) }, Cmd.none )

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
