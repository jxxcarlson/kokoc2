module Document.ActionEdit
    exposing
        ( renderLatex
        , createDocument
        , selectNewDocument
        , deleteDocumentFromList
        )

import Document.Default
import Document.Model exposing (Document, DocumentRecord, DocumentListRecord)
import Document.Data as Data
import Document.Cmd
import Document.Msg exposing (DocumentMsg(GetDocumentList, SaveDocument))
import Model
    exposing
        ( Model
        , Page(EditorPage)
        , DocumentMenuState(..)
        , MenuStatus(..)
        , NewDocumentPanelState(..)
        )
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


createDocument : Model -> Document -> ( Model, Cmd Msg )
createDocument model document =
    ( { model
        | page = EditorPage
        , documentMenuState = DocumentMenu MenuInactive
        , newDocumentPanelState = NewDocumentPanelInactive
      }
    , Document.Cmd.createDocumentCmd document (Utility.getToken model)
    )


selectNewDocument : Model -> Document -> ( Model, Cmd Msg )
selectNewDocument model document =
    ( { model
        | currentDocument = document
        , documentList = [ document ] ++ model.documentList
        , message = "New document added: " ++ document.title
        , counter = model.counter + 1
      }
    , Document.Cmd.putTextToRender document
    )


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
        ( { model | currentDocument = updatedDocument, editRecord = newEditRecord }
        , Cmd.batch
            [ Document.Cmd.putTextToRender updatedDocument
            , Task.attempt (Msg.DocumentMsg << SaveDocument)
                (Document.Task.saveDocumentTask (Utility.getToken model) updatedDocument)
            ]
        )


deleteDocumentFromList : Document -> Model -> Model
deleteDocumentFromList document model =
    let
        documentList =
            model.documentList

        updatedDocumentList =
            Utility.removeWhen (\doc -> doc.id == model.currentDocument.id) documentList

        newCurrentDocument =
            List.head updatedDocumentList |> Maybe.withDefault (Document.Default.make "Error" "There was an error deleting this documents.")
    in
        { model
            | message = "Document deleted, remaining = " ++ toString (List.length updatedDocumentList)
            , documentList = updatedDocumentList
            , currentDocument = newCurrentDocument
        }
