module Document.ActionRead
    exposing
        ( getDocuments
        , refreshDocumentList
        , loadParentDocument
        , selectDocument
        , getRandomDocuments
        , getRecentDocuments
        )

import Document.Default
import Document.Model
    exposing
        ( Document
        , DocumentRecord
        , DocumentListRecord
        , DocType(..)
        , SearchDomain(..)
        , DocumentAccessibility(..)
        )
import Document.Data as Data
import Document.Cmd
import Document.Msg exposing (DocumentMsg(GetDocumentList, LoadContentAndRender))
import Model exposing (Model, Page(..), SearchMenuState(..), MenuStatus(..))
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
import Document.Dictionary as Dictionary
import Utility.KeyValue as KeyValue
import Document.Utility


getDocuments : Result Http.Error DocumentListRecord -> Model -> ( Model, Cmd Msg )
getDocuments result model =
    case result of
        Ok documentListRecord ->
            getDocumentsAux documentListRecord model

        Err message ->
            ( { model | errorMessage = (toString message) }, Cmd.none )


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

        maybeMasterDocument =
            if headDocument.attributes.docType == Master then
                Just headDocument
            else
                Nothing

        currentDocument =
            if List.member model.currentDocument.id documentIdList then
                model.currentDocument
            else
                documentList
                    |> List.head
                    |> Maybe.withDefault (Document.Default.make "Empty document list" "Empty document list")
    in
        ( { model
            | currentDocument = currentDocument
            , documentList = documentList
            , maybePreviousDocument = Nothing
            , maybeMasterDocument = maybeMasterDocument
          }
        , loadContentsIfNecessary token headDocument documentList
        )


loadContentsIfNecessary : String -> Document -> List Document -> Cmd Msg
loadContentsIfNecessary token currentDocument documentList =
    if currentDocument.content == "Loading ..." || List.length documentList == 1 then
        Document.Cmd.getDocumentsAndContent token (List.take Configuration.maxDocs documentList)
    else
        Cmd.none


refreshDocumentList : Model -> DocumentRecord -> Model
refreshDocumentList model documentRecord =
    let
        document =
            documentRecord.document

        nextDocumentList =
            Document.Utility.replaceIf (Document.Utility.hasId document.id) document model.documentList
    in
        { model | documentList = nextDocumentList }


selectDocument : Model -> Document -> ( Model, Cmd Msg )
selectDocument model document =
    let
        currentMasterDocumentId =
            Debug.log "selectDocument, currentMasterDocumentId"
                (case model.maybeMasterDocument of
                    Nothing ->
                        0

                    Just masterDocument ->
                        masterDocument.id
                )

        updatedMaybeMasterDocument =
            if document.attributes.docType == Master then
                Just document
            else if document.parentId == currentMasterDocumentId then
                model.maybeMasterDocument
            else
                Nothing

        token =
            Utility.getToken model
    in
        ( { model
            | currentDocument = document
            , maybeMasterDocument = updatedMaybeMasterDocument
            , editRecord = MiniLatex.Driver.emptyEditRecord
            , documentType = document.attributes.docType
            , documentTextType = document.attributes.textType
            , counter = model.counter + 1
            , repositoryName = Document.Utility.archiveName model document
          }
        , Cmd.batch
            [ Document.Cmd.selectMasterOrRender model document
            , setTexMacroFileCmd document token
            ]
        )


getRandomDocuments : Model -> ( Model, Cmd Msg )
getRandomDocuments model =
    ( { model
        | page = ReaderPage
        , searchMenuState = SearchMenu MenuInactive
        , maybeMasterDocument = Nothing
      }
    , Document.Cmd.randomDocuments model
    )


getRecentDocuments : Model -> Int -> ( Model, Cmd Msg )
getRecentDocuments model daysBefore =
    let
        ( query, docAccess ) =
            case model.searchDomain of
                SearchPublic ->
                    ( "days_before=" ++ (toString daysBefore), PublicDocument )

                SearchPrivate ->
                    ( "days_before=" ++ (toString daysBefore), PrivateDocument )

                _ ->
                    ( "days_before=" ++ (toString daysBefore), PublicDocument )

        cmd =
            Document.Cmd.searchWithQueryCmd model docAccess query
    in
        ( { model
            | page = ReaderPage
            , searchMenuState = SearchMenu MenuInactive
            , maybeMasterDocument = Nothing
            , searchQuery = query
          }
        , cmd
        )


setTexMacroFileCmd document token =
    let
        maybeMacroFileId =
            KeyValue.getIntValueForKeyFromTagList "texmacros" document.tags
    in
        case (maybeMacroFileId) of
            Just id ->
                Dictionary.setItemInDict ("id=" ++ toString id) "texmacros" token

            Nothing ->
                Cmd.none



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
            | currentDocument = document
          }
        , Task.attempt (Msg.DocumentMsg << GetDocumentList) (Document.Task.selectMasterTask document.parentId (Utility.getToken model))
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
