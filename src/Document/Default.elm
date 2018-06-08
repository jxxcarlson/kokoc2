module Document.Default exposing (make, masterDocText)

import Document.Model exposing (Document, DocumentAttributes, TextType(..), DocType(..))
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
    DocumentAttributes False MeenyLatex Standard 0 "default" 0 Nothing


masterDocText =
    """
This is starter text for a master document.
Edit it to suit your needs.  The line "++ Table of Contents"
is mandatory.

++ Table of Contents
== 285 Nature Photography // comment
=== 284 Redwood Tree //
=== 386 Glacier //
=== 391 Matanuska Glacier //
=== 387 Bird // comment
=== 390 Butterfly //
== 287 Science Images // comment
=== 288 Ancient Bacteria // comment
=== 289 Stem Cells // comment
=== 291 Vibrio and Diatom // comment
"""
