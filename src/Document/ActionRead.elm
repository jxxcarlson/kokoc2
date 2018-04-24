module Document.ActionRead
    exposing
        ( getDocuments
        , loadContent
        , loadParentDocument
        , selectDocument
        )

import Document.Default
import Document.Model exposing (Document, DocumentRecord, DocumentListRecord, DocType(..))
import Document.Data as Data
import Document.Cmd
import Document.Msg exposing (DocumentMsg(GetDocumentList, LoadContentAndRender))
import Model exposing (Model)
import Msg exposing (Msg(DocumentMsg))
import Http
import OutsideInfo exposing (InfoForOutside(PutTextToRender))
import Configuration
import Document.QueryParser as QueryParser
import Document.Query as Query
import Utility
import Task exposing (Task)
import Document.Task
import MiniLatex.Driver


getDocuments : Result Http.Error DocumentListRecord -> Model -> ( Model, Cmd Msg )
getDocuments result model =
    case result of
        Ok documentListRecord ->
            getDocumentsAux documentListRecord model

        Err message ->
            ( { model | message = (toString message) }, Cmd.none )


getDocumentsAux : DocumentListRecord -> Model -> ( Model, Cmd Msg )
getDocumentsAux documentListRecord model =
    let
        token =
            getToken model

        documentList =
            List.take Configuration.maxDocs
                documentListRecord.documents

        documentIdList =
            List.map .id documentList

        headDocument =
            documentList
                |> List.head
                |> Maybe.withDefault (Document.Default.make "Empty document list" "Empty document list")

        currentDocument =
            if List.member model.currentDocument.id documentIdList then
                model.currentDocument
            else
                documentList
                    |> List.head
                    |> Maybe.withDefault (Document.Default.make "Empty document list" "Empty document list")
    in
        ( { model | currentDocument = currentDocument, documentList = documentList }
        , loadContentsIfNecessary token headDocument documentList
        )


loadContentsIfNecessary : String -> Document -> List Document -> Cmd Msg
loadContentsIfNecessary token currentDocument documentList =
    if currentDocument.content == "Loading ..." then
        Document.Cmd.getDocumentsAndContent token (List.take Configuration.maxDocs documentList)
    else
        Cmd.none


loadContent : Model -> DocumentRecord -> Model
loadContent model documentRecord =
    let
        document =
            documentRecord.document

        documentsInModel =
            model.documentList

        newDocumentList =
            replaceIf (hasId document.id) document documentsInModel
    in
        { model | documentList = newDocumentList }


selectDocument : Model -> Document -> ( Model, Cmd Msg )
selectDocument model document =
    let
        maybeMasterDocument =
            if document.attributes.docType == Master then
                Just document
            else
                Nothing
    in
        ( { model
            | currentDocument = document
            , masterDocLoaded = masterDocLoaded model document
            , masterDocumentId = masterDocumentId model document
            , masterDocumentTitle = masterDocumentTitle model document
            , maybeMasterDocument = maybeMasterDocument
            , editRecord = MiniLatex.Driver.emptyEditRecord
            , counter = model.counter + 1
          }
        , Document.Cmd.selectMasterOrRender model document
        )



{- MASTER DOCUMENT -}


loadParentDocument : Model -> Document -> ( Model, Cmd Msg )
loadParentDocument model document =
    let
        token =
            Utility.getToken model

        route =
            "/documents/" ++ toString model.currentDocument.id
    in
        ( { model
            | masterDocLoaded = True
            , masterDocumentId = model.currentDocument.parentId
            , masterDocumentTitle = model.currentDocument.parentTitle
            , currentDocument = document
          }
        , -- Task.attempt (DocumentMsg << GetDocumentList) (selectMasterTask |> Task.andThen (\_ -> refreshMasterDocumentTask))
          Task.attempt (Msg.DocumentMsg << GetDocumentList)
            (Document.Task.selectMasterTask document.parentId (Utility.getToken model))
          -- Task.attempt (Msg.DocumentMsg << LoadContentAndRender)
          --   ((Document.Task.selectMasterTask document.parentId (Utility.getToken model))
          --       |> Task.andThen (\_ -> Document.Task.getOneDocumentTask token route "" (Msg.DocumentMsg << LoadContentAndRender))
          --   )
        )



{- STAGING -}
{- HELPERS -}


getToken : Model -> String
getToken model =
    case model.maybeCurrentUser of
        Nothing ->
            ""

        Just user ->
            user.token


hasId : Int -> Document -> Bool
hasId id document =
    document.id == id


replaceIf : (a -> Bool) -> a -> List a -> List a
replaceIf predicate replacement list =
    List.map
        (\item ->
            if predicate item then
                replacement
            else
                item
        )
        list


masterDocLoaded : Model -> Document -> Bool
masterDocLoaded model document =
    if document.attributes.docType == Master then
        True
    else if model.masterDocumentId > 0 && document.parentId == model.masterDocumentId then
        True
    else
        False


masterDocumentId : Model -> Document -> Int
masterDocumentId model document =
    if document.attributes.docType == Master then
        document.id
    else if model.masterDocumentId > 0 && document.parentId == model.masterDocumentId then
        model.masterDocumentId
    else
        0


masterDocumentTitle : Model -> Document -> String
masterDocumentTitle model document =
    if document.attributes.docType == Master then
        document.title
    else if model.masterDocumentId > 0 && document.parentId == model.masterDocumentId then
        model.masterDocumentTitle
    else
        ""
