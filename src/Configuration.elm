module Configuration exposing (..)


host : String
host =
    "http://localhost:4000"


api : String
api =
    host ++ "/api"


client : String
client =
    "http://localhost:3000"


maxDocs =
    40
