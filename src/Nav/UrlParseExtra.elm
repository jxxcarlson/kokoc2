module Nav.UrlParseExtra exposing (id, getInitialIdFromLocation)

import Configuration
import Parser exposing (..)
import String.Extra


id : Parser Int
id =
    succeed identity
        |. symbol (Configuration.client ++ "/##public/")
        |= int


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
