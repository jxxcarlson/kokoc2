module Document.Msg exposing (DocumentMsg(..))

import Http
import Document.Model exposing (Document, DocumentRecord, DocumentListRecord)


type DocumentMsg
    = GetDocumentList (Result Http.Error DocumentListRecord)
    | SelectDocument Document
    | CreateDocument (Result Http.Error DocumentRecord)
    | LoadContent (Result Http.Error DocumentRecord)
    | LoadContentAndRender (Result Http.Error DocumentRecord)
    | SaveDocument (Result Http.Error DocumentRecord)
    | DeleteDocument (Result Http.Error String)
    | NewDocument
    | SearchOnKey Int
    | InputSearchQuery String
    | LoadParent Document
    | InputEditorText String
    | RenderContent
    | PrepareToDeleteDocument
    | DoDeleteDocument



-- DoDeleteDocument (Result Http.Error ())
