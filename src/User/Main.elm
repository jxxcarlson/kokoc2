module User.Main exposing (..)


type alias User =
    { name : String
    , id : Int
    , username : String
    , email : String
    , blurb : String
    , password : String
    , token : String
    , admin : Bool
    }
