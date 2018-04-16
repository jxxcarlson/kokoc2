module Utility exposing (getUserId, getToken, setPage)

import Model exposing (Model, Page(..))


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


setPage : Model -> Page
setPage model =
    if model.page == StartPage then
        ReaderPage
    else
        model.page
