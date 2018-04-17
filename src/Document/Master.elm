module Document.Master exposing (select)

import Utility
import Model exposing (Model)
import Msg exposing (Msg(DocumentMsg))
import Document.Cmd
import Document.Model exposing (Document)
import Document.Msg exposing (DocumentMsg(GetDocumentList))


select : Document -> Model -> Cmd Msg
select document model =
    let
        token =
            Utility.getToken model
    in
        if document.attributes.docType == "master" then
            selectAux document.id token
        else if document.parentId /= 0 then
            selectAux document.parentId token
        else
            Cmd.none


selectAux : Int -> String -> Cmd Msg
selectAux documentId token =
    let
        route =
            if token == " " then
                "/public/documents"
            else
                "/documents"

        query =
            "master=" ++ toString documentId ++ "&loading"
    in
        Document.Cmd.getDocuments token route query (DocumentMsg << GetDocumentList)
