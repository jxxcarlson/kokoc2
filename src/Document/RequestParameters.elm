module Document.RequestParameters exposing (getDocumentListParameters, getOneDocumentParameters)

import Configuration
import Document.Data as Data
import Model exposing (Model)
import Msg
import Document.Model exposing (Document, DocumentRecord, DocumentListRecord)
import Document.Msg exposing (DocumentMsg(..))
import HttpBuilder as HB
import Api.Request exposing (RequestParameters)
import Json.Encode as Encode
import Document.Data as Data


getDocumentListParameters : Api.Request.SetupRequestData DocumentListRecord
getDocumentListParameters token route tagger =
    { api = Configuration.api
    , route = route
    , payload = Encode.null
    , tagger = tagger
    , token = token
    , decoder = Data.documentListDecoder
    , method = HB.get
    }


getOneDocumentParameters : Api.Request.SetupRequestData DocumentRecord
getOneDocumentParameters token route tagger =
    { api = Configuration.api
    , route = route
    , payload = Encode.null
    , tagger = tagger
    , token = token
    , decoder = Data.documentRecordDecoder
    , method = HB.get
    }
