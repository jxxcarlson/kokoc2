port module Main exposing (main)

{- This app retrieves and displays weather data from openweathermap.org. -}

import Html
import Types exposing (Model, Msg(..))
import View exposing (view)
import OutsideInfo


type alias Flags =
    { width : Int
    , height : Int
    }



-- type Msg
--     = LogErr String
--     | Outside InfoForElm


type InfoForElm
    = RenderedText String


main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { message = "App started"
      , windowWidth = flags.width
      , windowHeight = flags.height
      }
    , Cmd.none
    )


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
