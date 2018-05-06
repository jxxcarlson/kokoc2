module User.Model exposing (User, UserRecord, UserListRecord)


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


type alias UserListRecord =
    { users : List User
    }
