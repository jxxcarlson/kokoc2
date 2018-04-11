port module Main exposing (main)

{- This app retrieves and displays weather data from openweathermap.org. -}

import Html
import OutsideInfo
import Model exposing (Model, Flags, initialModel)
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

        Input str ->
            ( { model | message = str }, Cmd.none )

        ReverseText ->
            ( { model | message = model.message |> String.reverse |> String.toLower }, Cmd.none )
