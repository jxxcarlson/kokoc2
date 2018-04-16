module Utility exposing (getUserId, getToken)

import Model exposing (Model)


getUserId : Model -> Int
getUserId model =
    case model.maybeCurrentUser of
        Nothing ->
            0

        Just user ->
            user.id


getToken : Model -> String
getToken model =
    case model.maybeCurrentUser of
        Nothing ->
            ""

        Just user ->
            user.token
