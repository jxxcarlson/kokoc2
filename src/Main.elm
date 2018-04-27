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


--

import Document.Cmd


main =
    Navigation.programWithFlags Nav.Parser.urlParser
        { init = init
        , view = View.Main.view
        , update = update
        , subscriptions = subscriptions
        }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    ( Model.initialModel flags
    , Cmd.batch
        [ OutsideInfo.sendInfoOutside (OutsideInfo.AskToReconnectUser Encode.null)
        , Document.Cmd.getDocuments "" "/public/documents" "random=public" (DocumentMsg << GetDocumentList)
        , Document.Cmd.loadDocumentIntoDictionary "" Configuration.startupDocumentId
        ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ OutsideInfo.getInfoFromOutside Outside LogErr
        ]
