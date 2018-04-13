module User.Msg exposing (..)

import Http
import User.Model exposing (UserRecord)


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
