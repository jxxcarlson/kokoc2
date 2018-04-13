module Model.Document exposing (..)

import Time exposing (Time)
import Dict


type alias Document =
    { id : Int
    , identifier : String
    , author_id : Int
    , author_name : String
    , access : AccessDict
    , title : String
    , content : String
    , rendered_content : String
    , attributes : DocumentAttributes
    , tags : List String
    , children : List Child
    , parent_id : Int
    , parent_title : String
    }


type alias Child =
    { title : String
    , level : Int
    , doc_identifier : String
    , doc_id : Int
    , comment : String
    }


type alias AccessDict =
    Dict.Dict String String


type alias DocumentAttributes =
    { public : Bool
    , textType : String
    , docType : String
    , level : Int
    , archive : String
    , version : Int
    , lastViewed : Maybe Time
    }
