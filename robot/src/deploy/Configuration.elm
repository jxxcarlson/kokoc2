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


initialTickerState =
    TickNever


host : String
host =
    "https://nshost.herokuapp.com"


client : String
client =
    "http://www.knode.io/"


client2 : String
client2 =
    "http://knode.io/"


api : String
api =
    host ++ "/api"


maxDocs =
    40


startupDocumentId =
    181
