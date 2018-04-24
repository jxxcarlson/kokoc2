module Document.Task
    exposing
        ( getDocumentsTask
        , getOneDocumentTask
        , selectMasterTask
        , saveDocumentTask
        , attachChildToMasterDocumentTask
        )

import Api.Request exposing (Tagger)
import Document.RequestParameters
import Document.Data as Data
import Document.Model exposing (Document, DocumentRecord, DocumentListRecord)
import Document.Msg exposing (DocumentMsg(..))
import Msg exposing (Msg(DocumentMsg))
import Task exposing (Task)
import Http
import Configuration
import Model exposing (Model, SubdocumentPosition(..))
import Json.Encode as Encode


getDocumentsTask : String -> String -> String -> Tagger DocumentListRecord -> Task Http.Error DocumentListRecord
getDocumentsTask token route query tagger =
    let
        routeAndQuery =
            if query == "" then
                route
            else
                route ++ "?" ++ query
    in
        Api.Request.makeTask <| Document.RequestParameters.getDocumentListParameters token routeAndQuery tagger


selectMasterTask : Int -> String -> Task Http.Error DocumentListRecord
selectMasterTask documentId token =
    let
        route =
            if token == "" then
                "/public/documents"
            else
                "/documents"

        query =
            "master=" ++ toString documentId ++ "&loading"
    in
        (getDocumentsTask token route query (DocumentMsg << GetDocumentList))


saveDocumentTask : String -> Document -> Task Http.Error DocumentRecord
saveDocumentTask token document =
    let
        route =
            "/documents/" ++ toString document.id

        encodedValue =
            Data.encodeDocumentRecord document

        tagger =
            Msg.DocumentMsg << SaveDocument
    in
        Api.Request.makeTask <| Document.RequestParameters.updateDocumentParameters token route encodedValue tagger


attachChildToMasterDocumentTask : Model -> String -> Int -> Task Http.Error DocumentRecord
attachChildToMasterDocumentTask model token childId =
    let
        query =
            case model.subdocumentPosition of
                SubdocumentAtTop ->
                    "?attach=at-top&child=" ++ (toString childId)

                SubdocumentAtBottom ->
                    "?attach=at-bottom&child=" ++ (toString childId)

                SubdocumentAboveCurrent ->
                    "?attach=above&child=" ++ (toString childId) ++ "current=" ++ (toString model.currentDocument.id)

                SubdocumentBelowCurrent ->
                    "?attach=below&child=" ++ (toString childId) ++ "current=" ++ (toString model.currentDocument.id)

                DoNotAttachSubdocument ->
                    ""

        route =
            "/documents/" ++ toString model.masterDocumentId ++ query

        encodedValue =
            case model.maybeMasterDocument of
                Nothing ->
                    Encode.null

                Just masterDocument ->
                    Data.encodeDocumentRecord masterDocument

        tagger =
            Msg.DocumentMsg << SaveDocument
    in
        Api.Request.makeTask <| Document.RequestParameters.updateDocumentParameters token route encodedValue tagger


getOneDocumentTask : String -> String -> String -> Tagger DocumentRecord -> Task Http.Error DocumentRecord
getOneDocumentTask token route query tagger =
    let
        routeAndQuery =
            if query == "" then
                route
            else
                route ++ "?" ++ query
    in
        Api.Request.makeTask <| Document.RequestParameters.getOneDocumentParameters token routeAndQuery tagger
