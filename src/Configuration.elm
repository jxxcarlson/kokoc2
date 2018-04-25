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



--"http://localhost:4000"


api : String
api =
    host ++ "/api"


client : String
client =
    "http://localhost:3000"


maxDocs =
    40


startupDocumentId =
    181
