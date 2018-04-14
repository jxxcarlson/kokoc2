module Document.RequestParameters exposing (..)

import Configuration
import Document.Data as Data
import Model exposing (Model)
import Msg
import Document.Model exposing (Document, DocumentListRecord)
import Document.Msg exposing (DocumentMsg(GetDocumentList))
import HttpBuilder as HB
import Api.Request exposing (RequestParameters)
import Json.Encode as Encode
import Document.Data as Data


documents : String -> String -> RequestParameters DocumentListRecord
documents token route =
    { api = Configuration.api
    , route = route
    , payload = Encode.null
    , tagger = Msg.DocumentMsg << GetDocumentList
    , token = token
    , decoder = Data.documentListDecoder
    , method = HB.get
    }
