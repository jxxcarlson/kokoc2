port module Main exposing (main)

{- This app retrieves and displays weather data from openweathermap.org. -}

import Json.Encode as Encode
import Html
import OutsideInfo
import Model exposing (Model, Flags, initialModel)
import Msg exposing (Msg(..))
import Update exposing (update)
import View.Main
import Document.Msg exposing (DocumentMsg(GetDocumentList))
import Configuration
import Nav.Parser
import Navigation
import Nav.UrlParseExtra
import Keyboard.Extra
import Time exposing (Time, second)


--

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
        id =
            Nav.UrlParseExtra.getInitialIdFromLocation location
    in
        if id > 0 then
            Navigation.newUrl (Configuration.client ++ "/##public/" ++ toString id)
        else
            Navigation.newUrl (Configuration.client ++ "/##public/181")


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    ( Model.initialModel flags
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
        , Time.every second Tick
        ]
