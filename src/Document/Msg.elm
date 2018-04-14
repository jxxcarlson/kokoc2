module Document.Msg exposing (..)

import Http
import Document.Model exposing (Document, DocumentListRecord)


type DocumentMsg
    = GetDocumentList (Result Http.Error DocumentListRecord)
    | SelectDocument Document
