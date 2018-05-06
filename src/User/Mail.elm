module User.Mail exposing (MailRecord, doMailing)

import Configuration
import User.Data as Data
import Model exposing (Model)
import Msg exposing (Msg)
import User.Model exposing (UserRecord, UserListRecord)
import User.Msg exposing (UserMsg(VerifyAuthentication, VerifySignUp, GetUser, GetUserList))
import HttpBuilder as HB
import Json.Encode as Encode
import Http
import Json.Decode as Decode exposing (at, field, int, list, string, decodeString, Decoder)
import Json.Decode.Pipeline as JPipeline exposing (decode, required, optional, hardcoded)


doMailingRequest : MailRecord -> RequestParameters MailResult -> HB.RequestBuilder MailResult
doMailingRequest mailRecord requestData =
    HB.post (requestUrl requestData)
        |> HB.withHeader "Authorization" ("Bearer " ++ requestData.token)
        |> HB.withJsonBody (mailingEncoder mailRecord)
        |> HB.withExpect (Http.expectJson mailingDecoder)


doMailing : MailRecord -> RequestParameters MailResult -> Cmd Msg
doMailing mailRecord requestData =
    doMailingRequest mailRecord requestData
        |> HB.send requestData.msg


requestUrl requestData =
    if requestData.query /= "" then
        (Configuration.api ++ requestData.route ++ "?" ++ requestData.query)
    else
        (Configuration.api ++ requestData.route)


mailingDecoder : Decoder MailResult
mailingDecoder =
    decode MailResult
        |> JPipeline.required "message" Decode.string


mailingEncoder : MailRecord -> Encode.Value
mailingEncoder mailRecord =
    case mailRecord.textType of
        Plain ->
            encodePlainTextMailing mailRecord

        Html ->
            encodeHtmlMailing mailRecord


encodePlainTextMailing : MailRecord -> Encode.Value
encodePlainTextMailing mailRecord =
    Encode.object
        [ ( "subject", Encode.string <| mailRecord.subject )
        , ( "recipient", Encode.string <| mailRecord.recipient )
        , ( "body", Encode.string <| mailRecord.recipient )
        , ( "type", Encode.string "plain_text" )
        ]


encodeHtmlMailing : MailRecord -> Encode.Value
encodeHtmlMailing mailRecord =
    Encode.object
        [ ( "subject", Encode.string <| mailRecord.subject )
        , ( "recipient", Encode.string <| mailRecord.recipient )
        , ( "body", Encode.string <| mailRecord.recipient )
        , ( "type", Encode.string "html_text" )
        ]


type alias RequestParameters msg =
    { route : String
    , query : String
    , msg : Result Http.Error msg -> Msg
    , token : String
    , jsonBody : Encode.Value
    }


type alias MailRecord =
    { subject : String
    , recipient : String
    , body : String
    , textType : TextType
    }


type TextType
    = Plain
    | Html


type alias MailResult =
    { message : String }
