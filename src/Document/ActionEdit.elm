module Document.ActionEdit
    exposing
        ( renderLatex
        )

import Document.Default
import Document.Model exposing (Document, DocumentRecord, DocumentListRecord)
import Document.Data as Data
import Document.Cmd
import Document.Msg exposing (DocumentMsg(GetDocumentList))
import Model exposing (Model)
import Msg exposing (Msg(DocumentMsg))
import Http
import OutsideInfo exposing (InfoForOutside(PutTextToRender))
import Configuration
import Document.QueryParser as QueryParser
import Document.Query as Query
import Utility
import Task exposing (Task)
import MiniLatex.Driver


renderLatex : Model -> ( Model, Cmd Msg )
renderLatex model =
    let
        document =
            model.currentDocument

        newEditRecord =
            MiniLatex.Driver.update 666 model.editRecord document.content

        renderedContent =
            Debug.log "renderedContent"
                (MiniLatex.Driver.getRenderedText "" newEditRecord)

        updatedDocument =
            { document | renderedContent = renderedContent }
    in
        ( { model | currentDocument = updatedDocument, editRecord = newEditRecord }, Document.Cmd.putTextToRender updatedDocument )
