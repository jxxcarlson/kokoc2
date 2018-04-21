module Utility exposing (getUserId, getToken, setPage, removeWhen)

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


removeWhen : (a -> Bool) -> List a -> List a
removeWhen pred list =
    List.filter (not << pred) list
