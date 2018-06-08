port module Main exposing (main)

{- This app retrieves and displays weather data from openweathermap.org. -}

import Json.Encode as Encode
import Html
import OutsideInfo
import Model exposing (Model, Flags, initialModel)
import Msg exposing (Msg(..))
import Update exposing (update)
import View.Main
import Document.Msg exposing (DocumentMsg(..))
import Configuration
import Nav.Parser
import Navigation
import Nav.UrlParseExtra
import Keyboard.Extra
import Time exposing (Time, second)
import Configuration exposing (TickerState(..))
import Document.Cmd


main =
    Navigation.programWithFlags Nav.Parser.urlParser
        { init = init
        , view = View.Main.view
        , update = update
        , subscriptions = subscriptions
        }


loadFromUrl location =
    let
        _ =
            Debug.log "loadFromUrl, location.href" location.href

        url =
            Debug.log "URL"
                (location.href
                    |> String.split "#"
                    |> List.head
                    |> Maybe.withDefault "http://www.knode.io"
                )

        id =
            Nav.UrlParseExtra.getInitialIdFromLocation location
    in
        if id > 0 then
            Navigation.newUrl (url ++ "##public/" ++ toString id)
        else
            Navigation.newUrl (url ++ "##public/181")



-- init : Flags -> Navigation.Location -> ( Model, Cmd Msg )


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    ( Model.initialModel flags location
    , Cmd.batch
        [ OutsideInfo.sendInfoOutside (OutsideInfo.AskToReconnectUser Encode.null)

        -- , Document.Cmd.getDocuments "" "/public/documents" "id=181" (DocumentMsg << GetDocumentList)
        -- , Document.Cmd.loadDocumentIntoDictionary "" Configuration.startupDocumentId
        , loadFromUrl location
        ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ OutsideInfo.getInfoFromOutside Outside LogErr
        , Sub.map KeyboardMsg Keyboard.Extra.subscriptions
        , runTicker model
        ]


runTicker model =
    case model.tickerState of
        TickNever ->
            Sub.none

        TickEachSecond ->
            Time.every second Tick

        TickSlowly ->
            Time.every (10 * second) Tick
