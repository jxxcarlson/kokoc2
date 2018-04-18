module Document.Cmd
    exposing
        ( getDocuments
        , getOneDocument
        , putTextToRender
        , getDocumentsAndContent
        , getDocumentsAndContent2
        , search
        , selectMaster
        , selectMasterTask
        , selectMasterOrRender
        )

import Model exposing (Model)
import Api.Request exposing (Tagger)
import Document.RequestParameters
import Document.Data as Data
import Document.Model exposing (Document, DocumentRecord, DocumentListRecord, SearchDomain(..), SortOrder)
import Document.Msg exposing (DocumentMsg(..))
import Msg exposing (Msg(DocumentMsg))
import OutsideInfo
import Task exposing (Task)
import Http
import Document.QueryParser as QueryParser
import Document.Query as Query
import Utility


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


getDocumentsAndContent2 : String -> List Document -> Cmd Msg
getDocumentsAndContent2 token documents =
    let
        idList =
            (List.map (\doc -> doc.id) documents)

        cmd =
            \id -> getOneDocument token ("/documents/" ++ (toString id)) "" (Msg.DocumentMsg << LoadContent)
    in
        Cmd.batch <| List.map cmd <| List.reverse idList



{- MASTER DOCUMENT -}


selectMasterOrRender : Model -> Document -> Cmd Msg
selectMasterOrRender model document =
    if document.attributes.docType == "master" then
        selectMaster document model
    else
        putTextToRender document


selectMaster : Document -> Model -> Cmd Msg
selectMaster document model =
    let
        token =
            Utility.getToken model
    in
        if document.attributes.docType == "master" then
            selectMasterAux document.id token
        else if document.parentId /= 0 then
            selectMasterAux document.parentId token
        else
            Cmd.none


selectMasterAux : Int -> String -> Cmd Msg
selectMasterAux documentId token =
    let
        route =
            if token == "" then
                "/public/documents"
            else
                "/documents"

        query =
            "master=" ++ toString documentId ++ "&loading"
    in
        Task.attempt (DocumentMsg << GetDocumentList) (getDocumentsTask token route query (DocumentMsg << GetDocumentList))


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



{- SEARCH -}


search : Model -> Cmd Msg
search model =
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
        getDocuments "" "/public/documents" query (Msg.DocumentMsg << GetDocumentList)


searchWithAuthorizationCmd : Model -> Cmd Msg
searchWithAuthorizationCmd model =
    let
        query =
            Query.makeQuery model.searchDomain model.sortOrder (Utility.getUserId model) model.searchQuery
    in
        getDocuments (Utility.getToken model) "/documents" query (Msg.DocumentMsg << GetDocumentList)



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
