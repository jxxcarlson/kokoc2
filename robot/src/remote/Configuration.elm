module Configuration
    exposing
        ( host
        , api
        , client
        , client2
        , maxDocs
        , startupDocumentId
        , TickerState(..)
        , initialTickerState
        )


type TickerState
    = TickNever
    | TickEachSecond
    | TickSlowly


host : String
host =
    "https://nshost.herokuapp.com"


client : String
client =
    "http://localhost:8080"


client2 : String
client2 =
    "http://localhost:8080"


api : String
api =
    host ++ "/api"


initialTickerState =
    TickNever


maxDocs =
    40


startupDocumentId =
    181
