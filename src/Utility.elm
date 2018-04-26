module Utility exposing (getUserId, getToken, setPage, removeWhen, compress, getUsername)

import Model exposing (Model, Page(..))
import String.Extra
import Regex


getUserId : Model -> Int
getUserId model =
    case model.maybeCurrentUser of
        Nothing ->
            0

        Just user ->
            user.id


getUsername : Model -> String
getUsername model =
    case model.maybeCurrentUser of
        Nothing ->
            ""

        Just user ->
            user.username


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



{- MORE STUFF -}


{-| map str to lower case and squeeze out bad characters
-}
compress : String -> String -> String
compress replaceBlank str =
    str
        |> String.toLower
        |> String.Extra.replace " " replaceBlank
        |> Regex.replace Regex.All (Regex.regex "[,;.!?&_]") (\_ -> "")


addLineNumbers text =
    text
        |> String.trim
        |> String.split "\n"
        |> List.foldl addNumberedLine ( 0, [] )
        |> Tuple.second
        |> List.reverse
        |> String.join "\n"


addNumberedLine line data =
    let
        ( k, lines ) =
            data
    in
        ( k + 1, [ numberedLine (k + 1) line ] ++ lines )


numberedLine k line =
    String.padLeft 5 ' ' (toString k) ++ "  " ++ line
