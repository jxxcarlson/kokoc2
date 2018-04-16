module Document.Cmd
    exposing
        ( getDocuments
        , getOneDocument
        , putTextToRender
        , getDocumentsAndContent
        , search
        )

import Api.Request exposing (Tagger)
import Document.RequestParameters
import Document.Data as Data
import Document.Model exposing (Document, DocumentRecord, DocumentListRecord, SearchDomain, SortType)
import Document.Msg exposing (DocumentMsg(..))
import Msg exposing (Msg)
import OutsideInfo
import Task exposing (Task)
import Http


getDocuments : String -> String -> String -> Tagger DocumentListRecord -> Cmd Msg
getDocuments token route query tagger =
    let
        routeAndQuery =
            if query == "" then
                route
            else
                route ++ "?" ++ query
    in
        Api.Request.doRequest <| Document.RequestParameters.getDocumentListParameters token routeAndQuery tagger


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


getOneDocument : String -> String -> String -> Tagger DocumentRecord -> Cmd Msg
getOneDocument token route query tagger =
    let
        routeAndQuery =
            if query == "" then
                route
            else
                route ++ "?" ++ query
    in
        Api.Request.doRequest <| Document.RequestParameters.getOneDocumentParameters token routeAndQuery tagger


putTextToRender : Document -> Cmd msg
putTextToRender document =
    let
        value =
            (Data.encodeDocumentForOutside document)
    in
        OutsideInfo.sendInfoOutside (OutsideInfo.PutTextToRender value)


getDocumentsAndContent : String -> List Document -> Cmd Msg
getDocumentsAndContent token documents =
    let
        idList =
            (List.map (\doc -> doc.id) documents)

        hCmd =
            \id -> getOneDocument token ("/documents/" ++ (toString id)) "" (Msg.DocumentMsg << LoadContentAndRender)

        tCmd =
            \id -> getOneDocument token ("/documents/" ++ (toString id)) "" (Msg.DocumentMsg << LoadContent)

        headCommand =
            case List.head idList of
                Just id ->
                    hCmd id

                Nothing ->
                    Cmd.none

        tailCommands =
            case List.tail idList of
                Just ids ->
                    List.map tCmd (List.reverse ids)

                Nothing ->
                    [ Cmd.none ]
    in
        Cmd.batch (tailCommands ++ [ headCommand ])


search : String -> SearchDomain -> SortType -> String -> Cmd Msg
search token searchDomain sortType searchQuery =
    let
        _ =
            Debug.log "SEARCH" searchQuery
    in
        Cmd.none



--
-- getDocuments2 : String -> String -> Int -> String -> Cmd Msg
-- getDocuments2 route query userId token =
--     let
--         query2 =
--             query ++ "&loading"
--
--         searchTask =
--             Request.Document.getDocumentsTask route query2 token
--     in
--         Task.attempt (DocumentMsg << GetUserDocuments) (searchTask |> Task.andThen (\documentsRecord -> refreshMasterDocumentTask route token documentsRecord))
--
--
--
--
-- {-| Called by getDocuments
-- -}
-- refreshMasterDocumentTask route token documentsRecord =
--     let
--         documents =
--             documentsRecord.documents
--
--         maybeFirstDocument =
--             List.head documents
--
--         ( isMasterDocument, masterDocumentId ) =
--             case maybeFirstDocument of
--                 Just document ->
--                     ( document.attributes.docType == "master", document.id )
--
--                 Nothing ->
--                     ( False, 0 )
--
--         task =
--             if (List.length documents == 1) && (isMasterDocument == True) then
--                 Request.Document.getDocumentsTask route ("master=" ++ toString masterDocumentId) token
--             else
--                 Task.succeed documentsRecord
--     in
--         task
