module Nav.UrlParseExtra exposing (id, idFromLocation, getInitialIdFromLocation)

import Configuration
import Parser exposing (..)
import String.Extra


id : Parser Int
id =
    succeed identity
        |. oneOf
            [ symbol (Configuration.client ++ "##public/")
            , symbol (Configuration.client2 ++ "##public/")
            ]
        |= int


idFromLocation location =
    Parser.run id location


getInitialIdFromLocation location =
    let
        _ =
            Debug.log "On startup, location.href" location.href

        loc =
            String.Extra.replace "#@" "##" location.href

        _ =
            Debug.log "On startup, loc" loc

        maybeId =
            Parser.run id loc

        _ =
            Debug.log "On startup, maybeId" maybeId
    in
        case maybeId of
            Result.Ok id ->
                id

            Err error ->
                0
