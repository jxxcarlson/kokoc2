module Document.Cmd exposing (..)

import Api.Request
import Document.RequestParameters
import Document.Data as Data
import Document.Model exposing (Document)
import Document.Msg exposing (DocumentMsg(..))
import Msg exposing (Msg)
import OutsideInfo


-- getDocuments : String -> String -> String -> Cmd Msg


getDocuments token route query tagger =
    let
        routeAndQuery =
            if query == "" then
                route
            else
                route ++ "?" ++ query
    in
        Api.Request.doRequest <| Document.RequestParameters.getDocumentListParameters token routeAndQuery tagger


getOneDocument token route query tagger =
    let
        routeAndQuery =
            if query == "" then
                route
            else
                route ++ "?" ++ query
    in
        Api.Request.doRequest <| Document.RequestParameters.getOneDocumentParameters token routeAndQuery tagger



-- route = "/public/documents?" ++ query


putTextToRender : Document -> Cmd msg
putTextToRender document =
    let
        value =
            (Data.encodeDocumentForOutside document)
    in
        OutsideInfo.sendInfoOutside (OutsideInfo.PutTextToRender value)



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
