port module OutsideInfo exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode
import Msg exposing (InfoForElm(..))
import User.Data as Data


port infoForOutside : GenericOutsideData -> Cmd msg


port infoForElm : (GenericOutsideData -> msg) -> Sub msg


type InfoForOutside
    = WindowData Encode.Value
    | UserData Encode.Value
    | AskToReconnectUser Encode.Value
    | DisconnectUser Encode.Value


type alias GenericOutsideData =
    { tag : String, data : Encode.Value }


sendInfoOutside : InfoForOutside -> Cmd msg
sendInfoOutside info =
    case info of
        WindowData value ->
            infoForOutside { tag = "WindowData", data = value }

        UserData value ->
            infoForOutside { tag = "UserData", data = value }

        AskToReconnectUser value ->
            infoForOutside { tag = "AskToReconnectUser", data = value }

        DisconnectUser value ->
            infoForOutside { tag = "DisconnectUser", data = value }


getInfoFromOutside : (InfoForElm -> msg) -> (String -> msg) -> Sub msg
getInfoFromOutside tagger onError =
    infoForElm
        (\outsideInfo ->
            case outsideInfo.tag of
                "ReconnectUser" ->
                    case Decode.decodeValue Data.userDecoderFromLocalStorage outsideInfo.data of
                        Ok result ->
                            tagger <| UserLoginInfo result

                        Err e ->
                            onError e

                _ ->
                    onError <| "Unexpected info from outside: " ++ toString outsideInfo
        )
