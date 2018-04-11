module Api.Main exposing (..)

import Configuration


host : String
host =
    Configuration.host


api : String
api =
    host ++ "/api"
