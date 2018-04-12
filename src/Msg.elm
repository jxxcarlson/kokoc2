module Msg exposing (..)

import Http


type Msg
    = NoOpz
    | UserMsg UserMsg


type UserMsg
    = SignIn
    | AuthenticateUser
    | VerifyAuthentication (Result Http.Error String)
    | SignUpUser
    | VerifySignUp (Result Http.Error UserRecord)
    | CancelSignIn
    | GoToSignupForm
    | UserNoOp
    | InputName String
    | InputUsername String
    | InputEmail String
    | InputPassword String


type alias User =
    { name : String
    , id : Int
    , username : String
    , email : String
    , blurb : String
    , token : String
    , admin : Bool
    }


type alias UserRecord =
    { user : User }
