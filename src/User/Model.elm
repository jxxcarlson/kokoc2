module User.Model exposing (User, UserRecord, UserListRecord, UserReply)


type alias User =
    { name : String
    , id : Int
    , username : String
    , email : String
    , blurb : String
    , token : String
    , admin : Bool
    , active : Bool
    }


type alias UserRecord =
    { user : User }


type alias UserListRecord =
    { users : List User
    }


type alias UserReply =
    { reply : String }
