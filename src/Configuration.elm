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


initialTickerState =
    TickNever


host : String
host =
    "https://nshost.herokuapp.com"


client : String
client =
    "http://www.knode.io"


api : String
api =
    host ++ "/api"


maxDocs =
    40


startupDocumentId =
    181
