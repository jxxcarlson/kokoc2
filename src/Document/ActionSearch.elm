module Document.ActionSearch
    exposing
        ( search
        )

import Document.Default
import Document.Model exposing (Document, DocumentRecord, DocumentListRecord, SearchDomain(..), SortOrder)
import Document.Data as Data
import Document.Cmd
import Document.Msg exposing (DocumentMsg(GetDocumentList))
import Model exposing (Model)
import Msg exposing (Msg(DocumentMsg))
import Http
import OutsideInfo exposing (InfoForOutside(PutTextToRender))
import Configuration
import Document.QueryParser as QueryParser
import Document.Query as Query
import Utility


search : Model -> ( Model, Cmd Msg )
search model =
    if model.searchDomain == SearchPublic then
        searchPublic model
    else
        searchWithAuthorization model


searchPublic : Model -> ( Model, Cmd Msg )
searchPublic model =
    let
        query =
            Query.makeQuery model.searchDomain model.sortOrder 0 model.searchQuery

        cmd =
            Document.Cmd.getDocuments "" "/public/documents" query (DocumentMsg << GetDocumentList)
    in
        ( { model | message = query }, cmd )


searchWithAuthorization : Model -> ( Model, Cmd Msg )
searchWithAuthorization model =
    let
        query =
            Query.makeQuery model.searchDomain model.sortOrder (Utility.getUserId model) model.searchQuery

        cmd =
            Document.Cmd.getDocuments (Utility.getToken model) "/documents" query (DocumentMsg << GetDocumentList)
    in
        ( { model | message = query }, cmd )
