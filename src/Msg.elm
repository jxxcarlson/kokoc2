module Msg exposing (..)


type Msg
    = NoOp
    | SignIn
    | CancelSignIn
    | GoToSignupForm
    | InputName String
    | InputUsername String
    | InputEmail String
    | InputPassword String
