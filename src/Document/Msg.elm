module Document.Msg exposing (DocumentMsg(..))

import Http
import Document.Model exposing (Document, DocumentRecord, DocumentListRecord)


type DocumentMsg
    = GetDocumentList (Result Http.Error DocumentListRecord)
    | SelectDocument Document
    | LoadContent (Result Http.Error DocumentRecord)
    | LoadContentAndRender (Result Http.Error DocumentRecord)
    | SearchOnKey Int
    | InputSearchQuery String
