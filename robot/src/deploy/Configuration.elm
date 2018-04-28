module Configuration
    exposing
        ( host
        , api
        , client
        , maxDocs
        , startupDocumentId
        )


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
