module User.Data exposing (..)

import Json.Encode as Encode
import Json.Decode as Decode exposing (decodeValue, field, map, map2, map3, field, at, int, list, string, decodeString, Decoder)
import Json.Decode.Pipeline as JPipeline exposing (decode, required, optional, hardcoded)


--

import User.Model exposing (UserRecord, UserListRecord, UserReply, User, NewUser)


type alias Claims =
    { username : String, user_id : Int }



{- ENCODERS -}


authenticationEncoder : String -> String -> Encode.Value
authenticationEncoder email password =
    Encode.object
        [ ( "authenticate"
          , Encode.object
                [ ( "email", Encode.string email )
                , ( "password", Encode.string password )
                ]
          )
        ]


signupUserEncoder : NewUser -> Encode.Value
signupUserEncoder newUser =
    Encode.object
        [ ( "user"
          , Encode.object
                [ ( "name", Encode.string <| newUser.name )
                , ( "username", Encode.string <| newUser.username )
                , ( "email", Encode.string <| newUser.email )
                , ( "password", Encode.string <| newUser.password )
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
        |> JPipeline.required "active" Decode.bool


userListDecoder : Decoder UserListRecord
userListDecoder =
    decode
        UserListRecord
        |> required "users" (Decode.list userDecoder)


decodeDeleteUserReply : Decoder UserReply
decodeDeleteUserReply =
    decode
        UserReply
        |> required "reply" Decode.string



-- (Decode.map elixirTFToBool Decode.string)


userDecoderFromLocalStorage : Decoder User
userDecoderFromLocalStorage =
    decode User
        |> JPipeline.required "name" Decode.string
        |> JPipeline.required "id" (Decode.map (String.toInt >> (Result.withDefault 0)) Decode.string)
        |> JPipeline.required "username" Decode.string
        |> JPipeline.required "email" Decode.string
        |> JPipeline.required "blurb" Decode.string
        |> JPipeline.required "token" Decode.string
        |> JPipeline.hardcoded False
        |> JPipeline.hardcoded True


elixirTFToBool : String -> Bool
elixirTFToBool str =
    case str of
        "Elixir.True" ->
            True

        "Elixir.False" ->
            False

        _ ->
            False
