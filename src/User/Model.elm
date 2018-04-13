module User.Model exposing (User, UserRecord)


type alias User =
    { name : String
    , id : Int
    , username : String
    , email : String
    , blurb : String
    , token : String
    , admin : Bool
    }


type alias UserRecord =
    { user : User }
