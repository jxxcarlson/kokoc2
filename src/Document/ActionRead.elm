module Document.ActionRead exposing (..)

import Document.Default
import Document.Model exposing (Document, DocumentRecord, DocumentListRecord)
import Document.Data as Data
import Document.Cmd
import Model exposing (Model)
import Msg exposing (Msg)
import Http
import Utility
import OutsideInfo exposing (InfoForOutside(PutTextToRender))


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
            case model.maybeCurrentUser of
                Nothing ->
                    ""

                Just user ->
                    user.token

        documentList =
            List.take 20
                documentListRecord.documents

        currentDocument =
            documentList
                |> List.head
                |> Maybe.withDefault (Document.Default.make "Empty document list" "Empty document list")
    in
        ( { model | currentDocument = currentDocument, documentList = documentList }
        , loadContentsIfNecessary token currentDocument documentList
        )


loadContentsIfNecessary token currentDocument documentList =
    if currentDocument.content == "Loading ..." then
        Document.Cmd.getDocumentsAndContent token (List.take 20 documentList)
    else
        Cmd.none



--, Document.Cmd.getDocumentsAndContent token documentList


loadContent : Model -> DocumentRecord -> ( Model, Cmd Msg )
loadContent model documentRecord =
    let
        document =
            documentRecord.document

        documentsInModel =
            model.documentList

        newDocumentList =
            Utility.replaceIf (hasId document.id) document documentsInModel
    in
        ( { model | documentList = newDocumentList }, Cmd.none )



{- HELPERS -}


hasId : Int -> Document -> Bool
hasId id document =
    document.id == id


loadContentAndRender : Model -> DocumentRecord -> ( Model, Cmd Msg )
loadContentAndRender model documentRecord =
    let
        document =
            documentRecord.document

        documentsInModel =
            model.documentList

        newDocumentList =
            Utility.replaceIf (hasId document.id) document documentsInModel
    in
        ( { model | documentList = newDocumentList, currentDocument = document }, Document.Cmd.putTextToRender document )
