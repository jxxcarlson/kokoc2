port module Main exposing (main)

{- This app retrieves and displays weather data from openweathermap.org. -}

import Json.Encode as Encode
import Html
import OutsideInfo
import Model exposing (Model, Flags, initialModel)
import Msg exposing (Msg(..))
import Update exposing (update)
import View.Main


main =
    Html.programWithFlags
        { init = init
        , view = View.Main.view
        , update = update
        , subscriptions = subscriptions
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model.initialModel flags, OutsideInfo.sendInfoOutside (OutsideInfo.AskToReconnectUser Encode.null) )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ OutsideInfo.getInfoFromOutside Outside LogErr
        ]
