module Api.Request
    exposing
        ( doRequest
        , makeTask
        , Tagger
        , RequestParameters
        , SetupRequestData
        , SetupRequestDataWithPayload
        )

import Http exposing (send)
import HttpBuilder as HB
import Json.Encode as Encode
import Json.Decode exposing (Decoder)
import Msg exposing (Msg)
import Task


type alias Tagger resourceType =
    Result Http.Error resourceType -> Msg


type alias SetupRequestData resourceType =
    String -> String -> Tagger resourceType -> RequestParameters resourceType


type alias SetupRequestDataWithPayload resourceType =
    String -> String -> Encode.Value -> Tagger resourceType -> RequestParameters resourceType


type alias RequestParameters resourceType =
    { api : String
    , route : String
    , payload : Encode.Value
    , tagger : Tagger resourceType
    , token : String
    , decoder : Decoder resourceType
    , method : String -> HB.RequestBuilder ()
    }


type alias RequestPacket resourceType =
    RequestParameters resourceType -> HB.RequestBuilder resourceType


putHeader : String -> HB.RequestBuilder a -> HB.RequestBuilder a
putHeader token =
    if token == "" then
        identity
    else
        HB.withHeader "Authorization" ("Bearer " ++ token)


setupRequest : RequestParameters resourceType -> RequestPacket resourceType
setupRequest requestData =
    \rqData ->
        (rqData.method (rqData.api ++ rqData.route)
            |> HB.withJsonBody rqData.payload
            |> putHeader rqData.token
            |> HB.withExpect (Http.expectJson rqData.decoder)
        )


doRequest : RequestParameters resourceType -> Cmd Msg
doRequest requestData =
    let
        request =
            setupRequest requestData
    in
        Http.send requestData.tagger (request requestData |> HB.toRequest)


makeTask : RequestParameters resourceType -> Task.Task Http.Error resourceType
makeTask requestData =
    let
        request =
            setupRequest requestData
    in
        Http.toTask (request requestData |> HB.toRequest)
