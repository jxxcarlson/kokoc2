module Configuration
    exposing
        ( host
        , api
        , client
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
    "http://localhost:4000"



--- "https://nshost.herokuapp.com"
-- "http://localhost:4000"


client : String
client =
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
