module User.RequestParameters exposing (..)

import Configuration
import User.Data as Data
import Model exposing (Model)
import Msg
import User.Model exposing (UserRecord)
import User.Msg exposing (UserMsg(VerifyAuthentication, VerifySignUp))
import HttpBuilder as HB
import Api.Request exposing (RequestParameters)


authenticateUser : Model -> RequestParameters String
authenticateUser model =
    { api = Configuration.api
    , route = "/authentication"
    , payload = Data.authenticationEncoder model
    , tagger = Msg.UserMsg << VerifyAuthentication
    , token = ""
    , decoder = Data.tokenDecoder
    , method = HB.post
    }


signUpUser : Model -> RequestParameters UserRecord
signUpUser model =
    { api = Configuration.api
    , route = "/users"
    , payload = Data.signupUserEncoder model
    , tagger = Msg.UserMsg << VerifySignUp
    , token = ""
    , decoder = Data.userRecordDecoder
    , method = HB.post
    }
