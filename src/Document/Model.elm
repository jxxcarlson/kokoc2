module Document.Model
    exposing
        ( Document
        , Child
        , DocumentAttributes
        , AccessDict
        , DocumentRecord
        , DocumentListRecord
        , SortOrder(..)
        , SortDirection(..)
        , SearchDomain(..)
        , TextType(..)
        , DocType(..)
        , DocumentDict
        , DocumentAccessibility(..)
        )

import Time exposing (Time)
import Dict exposing (Dict)


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
    , textType : TextType
    , docType : DocType
    , level : Int
    , archive : String
    , version : Int
    , lastViewed : Maybe Time
    }


type alias DocumentDict =
    Dict String Document


type DocType
    = Standard
    | Master


type TextType
    = MiniLatex
    | Asciidoc
    | AsciidocLatex
    | Plain


type DocumentAccessibility
    = PublicDocument
    | PrivateDocument


type alias DocumentRecord =
    { document : Document }


type alias DocumentListRecord =
    { documents : List Document
    }


type SearchDomain
    = SearchPublic
    | SearchPrivate
    | SearchAll
    | SearchShared


type SortDirection
    = Ascending
    | Descending


type SortOrder
    = ViewedOrder
    | UpdatedOrder
    | CreatedOrder
    | AlphabeticalOrder
