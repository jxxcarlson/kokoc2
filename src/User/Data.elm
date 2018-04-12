module User.Data exposing (..)

import Json.Encode as Encode
import Json.Decode as Decode exposing (decodeValue, field, map, map2, map3, field, at, int, list, string, decodeString, Decoder)
import Json.Decode.Pipeline as JPipeline exposing (decode, required, optional, hardcoded)
import Model exposing (Model)
import Msg exposing (UserRecord)


type alias Claims =
    { username : String, user_id : Int }



{- ENCODERS -}


authenticationEncoder : Model -> Encode.Value
authenticationEncoder model =
    Encode.object
        [ ( "authenticate"
          , Encode.object
                [ ( "email", Encode.string model.email )
                , ( "password", Encode.string model.password )
                ]
          )
        ]


signupUserEncoder : Model -> Encode.Value
signupUserEncoder model =
    Encode.object
        [ ( "user"
          , Encode.object
                [ ( "name", Encode.string <| model.name )
                , ( "username", Encode.string <| model.username )
                , ( "email", Encode.string <| model.email )
                , ( "password", Encode.string <| model.password )
                ]
          )
        ]


encodeUserData : User -> Encode.Value
encodeUserData user =
    Encode.object
        [ ( "name", Encode.string user.name )
        , ( "email", Encode.string user.email )
        , ( "id", Encode.int user.id )
        , ( "username", Encode.string user.username )
        , ( "blurb", Encode.string user.blurb )
        , ( "token", Encode.string user.token )
        ]



{- DECODERS -}


tokenDecoder : Decoder String
tokenDecoder =
    Decode.field "token" Decode.string


jwtDecoder : Decoder Claims
jwtDecoder =
    decode Claims
        |> JPipeline.required "username" Decode.string
        |> JPipeline.required "user_id" Decode.int


userRecordDecoder : Decoder UserRecord
userRecordDecoder =
    JPipeline.decode UserRecord
        |> JPipeline.required "user" (userDecoder)


userDecoder : Decoder User
userDecoder =
    decode User
        |> JPipeline.required "name" Decode.string
        |> JPipeline.required "id" Decode.int
        |> JPipeline.required "username" Decode.string
        |> JPipeline.required "email" Decode.string
        |> JPipeline.required "blurb" Decode.string
        |> JPipeline.required "token" Decode.string
        |> JPipeline.required "admin" Decode.bool


type alias User =
    { name : String
    , id : Int
    , username : String
    , email : String
    , blurb : String
    , token : String
    , admin : Bool
    }



-- registerUserEncoderOLD : Model -> Encode.Value
-- registerUserEncoderOLD model =
--     Encode.object
--         [ ( "user"
--           , Encode.object
--                 [ ( "name", Encode.string <| model.current_user.name )
--                 , ( "id", Encode.int <| model.current_user.id )
--                 , ( "username", Encode.string <| model.current_user.username )
--                 , ( "email", Encode.string <| model.current_user.email )
--                 , ( "password", Encode.string <| model.current_user.password )
--                 , ( "token", Encode.string <| model.current_user.token )
--                 , ( "admin", Encode.bool <| model.current_user.admin )
--                 , ( "blurb", Encode.string <| model.current_user.blurb )
--                 ]
--           )
--         ]
--
--
--
