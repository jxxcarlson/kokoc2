module User.Data exposing (..)

import Json.Encode as Encode
import Json.Decode exposing (decodeValue, map, map2, map3, field, at, int, list, string, decodeString, Decoder)
import Json.Decode.Pipeline as JPipeline exposing (decode, required, optional, hardcoded)


{- ENCODERS -}


signinEncoder : Model -> Encode.Value
signinEncoder model =
    Encode.object
        [ ( "authenticate"
          , Encode.object
                [ ( "email", Encode.string model.current_user.email )
                , ( "password", Encode.string model.current_user.password )
                ]
          )
        ]


registerUserEncoder : Model -> Encode.Value
registerUserEncoder model =
    Encode.object
        [ ( "user"
          , Encode.object
                [ ( "name", Encode.string <| model.current_user.name )
                , ( "id", Encode.int <| model.current_user.id )
                , ( "username", Encode.string <| model.current_user.username )
                , ( "email", Encode.string <| model.current_user.email )
                , ( "password", Encode.string <| model.current_user.password )
                , ( "token", Encode.string <| model.current_user.token )
                , ( "admin", Encode.bool <| model.current_user.admin )
                , ( "blurb", Encode.string <| model.current_user.blurb )
                ]
          )
        ]



{- DECODERS -}


jwtDecoder : Decoder Claims
jwtDecoder =
    decode Claims
        |> JPipeline.required "username" Json.Decode.string
        |> JPipeline.required "user_id" Json.Decode.int


userDecoder : Decoder LoginUserRecord
userDecoder =
    decode LoginUserRecord
        |> JPipeline.required "name" Json.Decode.string
        |> JPipeline.required "username" Json.Decode.string
        |> JPipeline.required "id" Json.Decode.int
        |> JPipeline.required "email" Json.Decode.string
        |> JPipeline.required "token" Json.Decode.string
        |> JPipeline.required "blurb" Json.Decode.string
