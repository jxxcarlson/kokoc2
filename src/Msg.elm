module Msg exposing (..)

import Http
import Model exposing (User)


type Msg
    = NoOpz
    | UserMsg UserMsg
    | Outside InfoForElm
    | LogErr String


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


type InfoForElm
    = UserLoginInfo User


type alias UserRecord =
    { user : User }
