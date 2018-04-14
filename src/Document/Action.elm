module Document.Action exposing (..)

import Document.Default
import Document.Model exposing (DocumentListRecord)
import Model exposing (Model)
import Msg exposing (Msg)
import Http


getDocuments : Result Http.Error DocumentListRecord -> Model -> ( Model, Cmd Msg )
getDocuments result model =
    case result of
        Ok documentListRecord ->
            putDocumentList documentListRecord model

        Err message ->
            ( model, Cmd.none )


putDocumentList : DocumentListRecord -> Model -> ( Model, Cmd Msg )
putDocumentList documentListRecord model =
    let
        documentList =
            documentListRecord.documents

        currentDocument =
            documentList
                |> List.head
                |> Maybe.withDefault (Document.Default.make "Empty document list" "Empty document list")
    in
        ( { model | currentDocument = currentDocument, documentList = documentList }, Cmd.none )
