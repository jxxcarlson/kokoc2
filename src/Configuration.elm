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
    "https://nshost.herokuapp.com"


client : String
client =
    "http://www.knode.io"


api : String
api =
    host ++ "/api"


initialTickerState =
    TickNever


maxDocs =
    40


startupDocumentId =
    181
