module Document.Msg exposing (..)

import Http
import Document.Model exposing (DocumentListRecord)


type DocumentMsg
    = GetDocumentList (Result Http.Error DocumentListRecord)
