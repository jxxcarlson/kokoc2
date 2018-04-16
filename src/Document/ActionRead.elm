module Document.ActionRead
    exposing
        ( getDocuments
        , loadContent
        , search
        )

import Document.Default
import Document.Model exposing (Document, DocumentRecord, DocumentListRecord)
import Document.Data as Data
import Document.Cmd
import Model exposing (Model)
import Msg exposing (Msg)
import Http
import OutsideInfo exposing (InfoForOutside(PutTextToRender))
import Configuration
import Document.QueryParser as QueryParser


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

        currentDocument =
            documentList
                |> List.head
                |> Maybe.withDefault (Document.Default.make "Empty document list" "Empty document list")
    in
        ( { model | currentDocument = currentDocument, documentList = documentList }
        , loadContentsIfNecessary token currentDocument documentList
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


search : Model -> ( Model, Cmd Msg )
search model =
    let
        query =
            QueryParser.parseQuery model.searchQuery
    in
        ( { model | message = query }, Cmd.none )



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
