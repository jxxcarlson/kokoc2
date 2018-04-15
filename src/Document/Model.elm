module Document.Model
    exposing
        ( Document
        , Child
        , DocumentAttributes
        , AccessDict
        , DocumentRecord
        , DocumentListRecord
        , SortType(..)
        , SortDirection(..)
        , SearchDomain(..)
        )

import Time exposing (Time)
import Dict


type alias Document =
    { id : Int
    , identifier : String
    , authorId : Int
    , authorName : String
    , access : AccessDict
    , title : String
    , content : String
    , renderedContent : String
    , attributes : DocumentAttributes
    , tags : List String
    , children : List Child
    , parentId : Int
    , parentTitle : String
    }


type alias Child =
    { title : String
    , level : Int
    , docIdentifier : String
    , docId : Int
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


type alias DocumentRecord =
    { document : Document }


type alias DocumentListRecord =
    { documents : List Document
    }


type SearchDomain
    = SearchPublic
    | SearchPrivate
    | SearchAll


type SortDirection
    = Ascending
    | Descending


type SortType
    = Title
    | Updated
