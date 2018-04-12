module Msg exposing (..)

import Http
import Model exposing (User)


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


type alias UserRecord =
    { user : User }
