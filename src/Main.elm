port module Main exposing (main)

{- This app retrieves and displays weather data from openweathermap.org. -}

import Html
import OutsideInfo
import Model exposing (Model, Flags, initialModel, Mode(..))
import Msg exposing (Msg(..))
import View.Main


type InfoForElm
    = RenderedText String


main =
    Html.programWithFlags
        { init = init
        , view = View.Main.view
        , update = update
        , subscriptions = subscriptions
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model.initialModel flags, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [-- OutsideInfo.getInfoFromOutside Outside LogErr
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SignIn ->
            ( { model | mode = SigningIn }, Cmd.none )

        CancelSignIn ->
            ( { model | mode = Public }, Cmd.none )

        GoToSignupForm ->
            ( { model | mode = SigningUp }, Cmd.none )

        InputName str ->
            ( { model | name = str }, Cmd.none )

        InputUsername str ->
            ( { model | username = str }, Cmd.none )

        InputEmail str ->
            ( { model | email = str }, Cmd.none )

        InputPassword str ->
            ( { model | password = str }, Cmd.none )
