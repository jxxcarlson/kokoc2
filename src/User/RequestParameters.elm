module User.RequestParameters exposing (..)

import Configuration
import User.Data as Data
import Model exposing (Model)
import Msg exposing (Msg(UserMsg), UserMsg(..))
import HttpBuilder as HB
import Api.Request exposing (RequestParameters)


authenticateUser : Model -> RequestParameters String
authenticateUser model =
    { api = Configuration.api
    , route = "/authentication"
    , payload = Data.authenticationEncoder model
    , tagger = UserMsg << VerifyAuthentication
    , token = ""
    , decoder = Data.tokenDecoder
    , method = HB.post
    }


signUpUser : Model -> RequestParameters Msg.UserRecord
signUpUser model =
    { api = Configuration.api
    , route = "/users"
    , payload = Data.signupUserEncoder model
    , tagger = UserMsg << VerifySignUp
    , token = ""
    , decoder = Data.userRecordDecoder
    , method = HB.post
    }
