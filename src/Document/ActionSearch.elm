module Document.ActionSearch
    exposing
        ( searchCmd
        )

import Document.Default
import Document.Model exposing (Document, DocumentRecord, DocumentListRecord, SearchDomain(..), SortOrder)
import Document.Data as Data
import Document.Cmd
import Document.Msg exposing (DocumentMsg(GetDocumentList))
import Model exposing (Model, Page(..))
import Msg exposing (Msg(DocumentMsg))
import Http
import OutsideInfo exposing (InfoForOutside(PutTextToRender))
import Configuration
import Document.QueryParser as QueryParser
import Document.Query as Query
import Utility


searchCmd : Model -> Cmd Msg
searchCmd model =
    if model.searchDomain == SearchPublic then
        searchPublicCmd model
    else
        searchWithAuthorizationCmd model


searchPublicCmd : Model -> Cmd Msg
searchPublicCmd model =
    let
        query =
            Query.makeQuery model.searchDomain model.sortOrder 0 model.searchQuery
    in
        Document.Cmd.getDocuments "" "/public/documents" query (DocumentMsg << GetDocumentList)


searchWithAuthorizationCmd : Model -> Cmd Msg
searchWithAuthorizationCmd model =
    let
        query =
            Query.makeQuery model.searchDomain model.sortOrder (Utility.getUserId model) model.searchQuery
    in
        Document.Cmd.getDocuments (Utility.getToken model) "/documents" query (DocumentMsg << GetDocumentList)
