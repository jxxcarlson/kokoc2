module User.RequestParameters exposing (..)

import Json.Encode as Encode
import HttpBuilder as HB


--

import Configuration
import Api.Request exposing (RequestParameters)
import Msg


--

import User.Data as Data
import User.Model exposing (UserRecord, UserListRecord, UserReply, NewUser)
import User.Msg exposing (UserMsg(VerifyAuthentication, VerifySignUp, GetUser, GetUserList, ProcessDeletedDocument))


authenticateUser : String -> String -> RequestParameters String
authenticateUser email password =
    { api = Configuration.api
    , route = "/authentication"
    , payload = Data.authenticationEncoder email password
    , tagger = Msg.UserMsg << VerifyAuthentication
    , token = ""
    , decoder = Data.tokenDecoder
    , method = HB.post
    }


signUpUser : NewUser -> RequestParameters UserRecord
signUpUser newUser =
    { api = Configuration.api
    , route = "/users"
    , payload = Data.signupUserEncoder newUser
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


deleteUser : String -> Int -> RequestParameters UserReply
deleteUser token userId =
    { api = Configuration.api
    , route = "/users/" ++ (toString userId)
    , payload = Encode.null
    , tagger = Msg.UserMsg << ProcessDeletedDocument
    , token = token
    , decoder = Data.decodeDeleteUserReply
    , method = HB.delete
    }
