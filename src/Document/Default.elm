module Document.Default exposing (make)

import Document.Model exposing (Document, DocumentAttributes)
import Dict


make : String -> String -> Document
make title content =
    let
        doc =
            emptyDocument
    in
        { doc | title = title, content = content, renderedContent = content }


emptyDocument : Document
emptyDocument =
    { id = 0
    , identifier = "-"
    , authorId = 0
    , authorName = ""
    , access = Dict.empty
    , title = ""
    , content = ""
    , renderedContent = ""
    , attributes = defaultAttributes
    , tags = []
    , children = []
    , parentId = 0
    , parentTitle = "-"
    }


defaultAttributes : DocumentAttributes
defaultAttributes =
    DocumentAttributes False "adoc" "standard" 0 "default" 0 Nothing
