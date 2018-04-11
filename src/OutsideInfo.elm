port module OutsideInfo exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode


type InfoForOutside
    = WindowData Encode.Value


type InfoForElm
    = String


type alias GenericOutsideData =
    { tag : String, data : Encode.Value }


sendInfoOutside : InfoForOutside -> Cmd msg
sendInfoOutside info =
    case info of
        WindowData value ->
            infoForOutside { tag = "WindowData", data = value }


getInfoFromOutside : (InfoForElm -> msg) -> (String -> msg) -> Sub msg
getInfoFromOutside tagger onError =
    infoForElm
        (\outsideInfo ->
            case outsideInfo.tag of
                _ ->
                    onError <| "Unexpected info from outside: " ++ toString outsideInfo
        )


port infoForOutside : GenericOutsideData -> Cmd msg


port infoForElm : (GenericOutsideData -> msg) -> Sub msg
