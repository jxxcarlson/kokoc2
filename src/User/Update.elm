module User.Update exposing (..)

import Model exposing (Model, Flags, initialModel, Mode(..))
import Msg exposing (Msg)
import User.Msg exposing (..)
import Api.Request as Request
import User.RequestParameters as RequestParameters
import User.Action as Action


-- type alias User =
--     { name : String
--     , id : Int
--     , username : String
--     , email : String
--     , blurb : String
--     , password : String
--     , token : String
--     , admin : Bool
--     }
--


update : UserMsg -> Model -> ( Model, Cmd Msg )
update submessage model =
    case submessage of
        SignIn ->
            ( { model | mode = Action.setMode model }, Action.signOutCommand model )

        AuthenticateUser ->
            ( model, Request.doRequest <| RequestParameters.authenticateUser model )

        VerifyAuthentication (Ok token) ->
            Action.handleToken model token

        VerifyAuthentication (Err error) ->
            ( { model | message = (toString error) }, Cmd.none )

        SignUpUser ->
            ( model, Request.doRequest <| RequestParameters.signUpUser model )

        VerifySignUp (Ok userRecord) ->
            Action.handleUserRecord model userRecord

        VerifySignUp (Err error) ->
            ( { model | message = (toString error) }, Cmd.none )

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
