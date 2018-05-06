module User.RequestParameters exposing (..)

import Configuration
import User.Data as Data
import Model exposing (Model)
import Msg
import User.Model exposing (UserRecord, UserListRecord)
import User.Msg exposing (UserMsg(VerifyAuthentication, VerifySignUp, GetUser, GetUserList))
import HttpBuilder as HB
import Api.Request exposing (RequestParameters)
import Json.Encode as Encode


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


getUser : Int -> RequestParameters UserRecord
getUser userId =
    { api = Configuration.api
    , route = "/users/" ++ (toString userId)
    , payload = Encode.null
    , tagger = Msg.UserMsg << GetUser
    , token = ""
    , decoder = Data.userRecordDecoder
    , method = HB.get
    }


getUserList : RequestParameters UserListRecord
getUserList =
    { api = Configuration.api
    , route = "/users/"
    , payload = Encode.null
    , tagger = Msg.UserMsg << GetUserList
    , token = ""
    , decoder = Data.userListDecoder
    , method = HB.get
    }
