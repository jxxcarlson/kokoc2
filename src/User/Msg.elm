module User.Msg exposing (..)

import Http
import User.Model exposing (UserRecord, UserListRecord)


type UserMsg
    = SignIn
    | AuthenticateUser
    | VerifyAuthentication (Result Http.Error String)
    | SignUpUser
    | VerifySignUp (Result Http.Error UserRecord)
    | GetUser (Result Http.Error UserRecord)
    | GetUserList (Result Http.Error UserListRecord)
    | CancelSignIn
    | GoToSignupForm
    | UserNoOp
    | InputName String
    | InputUsername String
    | InputEmail String
    | InputPassword String
