module Document.Cmd
    exposing
        ( getDocuments
        , getOneDocument
        , loadDocumentIntoDictionary
        , putTextToRender
        , getDocumentsAndContent
        , search
        , selectMaster
        , selectMasterOrRender
        , searchWithQueryCmd
        , renderNonLatexCmd
        , createDocumentCmd
        , deleteDocument
        , saveDocumentCmd
        , saveDocumentListCmd
        , randomDocuments
        , updateSharingData
        )

import Model exposing (Model)
import Api.Request exposing (Tagger)
import Document.RequestParameters
import Document.Data as Data
import Document.Model
    exposing
        ( Document
        , DocumentRecord
        , DocumentListRecord
        , SearchDomain(..)
        , SortOrder
        , DocType(..)
        , DocumentAccessibility(..)
        )
import Document.Msg exposing (DocumentMsg(..))
import Msg exposing (Msg(DocumentMsg))
import OutsideInfo
import Task exposing (Task)
import Http
import Document.QueryParser as QueryParser
import Document.Query as Query
import Utility
import Document.Task


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


getOneDocument : String -> String -> String -> Tagger DocumentRecord -> Cmd Msg
getOneDocument token route query tagger =
    let
        routeAndQuery =
            (if query == "" then
                route
             else
                route ++ "?" ++ query
            )
    in
        Api.Request.doRequest <| Document.RequestParameters.getOneDocumentParameters token routeAndQuery tagger


loadDocumentIntoDictionary : String -> Int -> Cmd Msg
loadDocumentIntoDictionary token id =
    getOneDocument token ("/public/documents/" ++ (toString id)) "" (Msg.DocumentMsg << LoadIntoDictionary)


deleteDocument : String -> Int -> Cmd Msg
deleteDocument token documentId =
    let
        route =
            "/documents/" ++ toString documentId
    in
        Api.Request.doRequest <| Document.RequestParameters.deleteDocumentParameters token route (Msg.DocumentMsg << DeleteDocument)


putTextToRender : Document -> Cmd msg
putTextToRender document =
    let
        _ =
            Debug.log "putTextToRender, chars" (String.length document.content)

        value =
            (Data.encodeDocumentForOutside document)
    in
        OutsideInfo.sendInfoOutside (OutsideInfo.PutTextToRender value)


documentRoute : Document -> String
documentRoute document =
    if document.attributes.public then
        "/public/documents/"
    else
        "/documents/"


getDocumentsAndContent : String -> List Document -> Cmd Msg
getDocumentsAndContent token documents =
    let
        idList =
            (List.map (\doc -> ( doc.id, documentRoute doc )) documents)

        hCmd =
            \( id, route ) -> getOneDocument token (route ++ (toString id)) "" (Msg.DocumentMsg << LoadContentAndRender)

        tCmd =
            \( id, route ) -> getOneDocument token (route ++ (toString id)) "" (Msg.DocumentMsg << LoadContent)

        headCommand =
            case List.head idList of
                Just ( id, route ) ->
                    hCmd ( id, route )

                Nothing ->
                    Cmd.none

        tailCommands =
            case List.tail idList of
                Just ids ->
                    List.map tCmd (List.reverse ids)

                Nothing ->
                    [ Cmd.none ]

        commands =
            tailCommands ++ [ headCommand ]
    in
        Cmd.batch commands



{- MASTER DOCUMENT -}


selectMasterOrRender : Model -> Document -> Cmd Msg
selectMasterOrRender model document =
    if document.attributes.docType == Master then
        selectMaster document model
    else
        putTextToRender document


selectMaster : Document -> Model -> Cmd Msg
selectMaster document model =
    let
        token =
            Utility.getToken model
    in
        if document.attributes.docType == Master then
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
        Task.attempt (DocumentMsg << GetDocumentList) (Document.Task.getDocumentsTask token route query (DocumentMsg << GetDocumentList))



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

        token =
            ""
    in
        getDocuments token "/public/documents" query (Msg.DocumentMsg << GetDocumentList)


searchWithAuthorizationCmd : Model -> Cmd Msg
searchWithAuthorizationCmd model =
    let
        query =
            Query.makeQuery model.searchDomain model.sortOrder (Utility.getUserId model) model.searchQuery

        token =
            Utility.getToken model
    in
        getDocuments token "/documents" query (Msg.DocumentMsg << GetDocumentList)


searchWithQueryCmd : Model -> DocumentAccessibility -> String -> Cmd Msg
searchWithQueryCmd model accessibility queryString =
    let
        query =
            Query.makeImmediateQuery model.searchDomain model.sortOrder (Utility.getUserId model) queryString
    in
        case accessibility of
            PublicDocument ->
                getDocuments "" "/public/documents" query (Msg.DocumentMsg << GetDocumentList)

            PrivateDocument ->
                getDocuments (Utility.getToken model) "/documents" query (Msg.DocumentMsg << GetDocumentList)


randomDocuments : Model -> Cmd Msg
randomDocuments model =
    let
        token =
            Utility.getToken model

        query =
            case model.searchDomain of
                SearchPublic ->
                    "random=public"

                SearchPrivate ->
                    "random_user=" ++ (toString <| Utility.getUserId model)

                SearchAll ->
                    "random=all"

                SearchShared ->
                    "random_user=" ++ (toString <| Utility.getUserId model)

        cmd =
            if model.searchDomain == SearchPublic then
                getDocuments token "/public/documents" query (Msg.DocumentMsg << GetDocumentList)
            else
                getDocuments token "/documents" query (Msg.DocumentMsg << GetDocumentList)
    in
        cmd


renderNonLatexCmd : Model -> Cmd Msg
renderNonLatexCmd model =
    Cmd.batch
        [ putTextToRender model.currentDocument
        , saveDocumentCmd model.currentDocument (Utility.getToken model)
        ]


createDocumentCmd : Document -> String -> Cmd Msg
createDocumentCmd document token =
    let
        encodedDocument =
            Data.encodeDocumentRecord document
    in
        Api.Request.doRequest <|
            Document.RequestParameters.postDocumentRecordParameters token "/documents" encodedDocument (Msg.DocumentMsg << CreateDocument)


saveDocumentCmd : Document -> String -> Cmd Msg
saveDocumentCmd document token =
    if token == "" then
        Cmd.none
    else
        Task.attempt (Msg.DocumentMsg << SaveDocument) (Document.Task.saveDocumentTask token document)


saveDocumentListCmd : List Document -> Model -> Cmd Msg
saveDocumentListCmd documentList model =
    let
        cmds =
            documentList
                |> List.map (\doc -> saveDocumentCmd doc (Utility.getToken model))
    in
        Cmd.batch cmds


updateSharingData : Model -> Cmd Msg
updateSharingData model =
    let
        parts =
            String.split ":" model.shareDocumentCommand

        maybeUsername =
            parts |> List.take 1 |> List.head

        maybeAction =
            parts |> List.drop 1 |> List.head

        finalSegment =
            case ( maybeUsername, maybeAction ) of
                ( Just username, Just action ) ->
                    (String.trim username) ++ "/" ++ (String.trim action)

                ( _, _ ) ->
                    ""

        token =
            Utility.getToken model

        route =
            (if finalSegment == "" then
                ""
             else
                "/share/" ++ ((toString model.currentDocument.id) ++ "/" ++ finalSegment)
            )

        encodedValue =
            Data.encodeDocumentRecord model.currentDocument
    in
        Api.Request.doRequest <|
            Document.RequestParameters.shareDocumentParameters token route encodedValue (Msg.DocumentMsg << SaveDocument)
