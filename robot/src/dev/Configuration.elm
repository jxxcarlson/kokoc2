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



-- "http://localhost:4000"


client : String
client =
    "http://localhost:8080"


api : String
api =
    host ++ "/api"


maxDocs =
    40


startupDocumentId =
    181
