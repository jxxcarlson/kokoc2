module Document.Default exposing (make)

import Model.Document exposing (Document, DocumentAttributes)
import Dict


make : String -> String -> Document
make title content =
    let
        doc =
            emptyDocument
    in
        { doc | title = title, content = content, rendered_content = content }


emptyDocument : Document
emptyDocument =
    { id = 0
    , identifier = "-"
    , author_id = 0
    , author_name = ""
    , access = Dict.empty
    , title = ""
    , content = ""
    , rendered_content = ""
    , attributes = defaultAttributes
    , tags = []
    , children = []
    , parent_id = 0
    , parent_title = "-"
    }


defaultAttributes : DocumentAttributes
defaultAttributes =
    DocumentAttributes False "adoc" "standard" 0 "default" 0 Nothing
