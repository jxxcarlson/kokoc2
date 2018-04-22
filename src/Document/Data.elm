module Document.Data
    exposing
        ( documentDecoder
        , documentRecordDecoder
        , documentListDecoder
        , decodeDeleteDocumentReply
        , encodeDocumentForOutside
        , encodeDocumentRecord
        )

import Json.Encode as Encode exposing (..)
import Json.Decode as Decode exposing (at, int, list, string, decodeString, Decoder)
import Json.Decode.Pipeline as JPipeline exposing (decode, required, optional, hardcoded)
import Document.Model
    exposing
        ( Document
        , DocumentRecord
        , DocumentAttributes
        , Child
        , DocumentListRecord
        , TextType(..)
        , DocType(..)
        )
import Document.Preprocess


{- DOCUMENT DECODERS -}


documentRecordDecoder : Decoder DocumentRecord
documentRecordDecoder =
    JPipeline.decode DocumentRecord
        |> JPipeline.required "document" (documentDecoder)


documentDecoder : Decoder Document
documentDecoder =
    decode Document
        |> JPipeline.required "id" Decode.int
        |> JPipeline.required "identifier" Decode.string
        |> JPipeline.required "author_id" Decode.int
        |> JPipeline.required "author_name" Decode.string
        |> JPipeline.required "access" (Decode.dict Decode.string)
        |> JPipeline.required "title" Decode.string
        |> JPipeline.required "content" Decode.string
        |> JPipeline.required "rendered_content" Decode.string
        |> JPipeline.required "attributes" (documentAttributesDecoder)
        |> JPipeline.required "tags" (Decode.list Decode.string)
        |> JPipeline.required "children" (Decode.list decodeChild)
        |> JPipeline.required "parent_id" Decode.int
        |> JPipeline.required "parent_title" Decode.string


documentAttributesDecoder : Decoder DocumentAttributes
documentAttributesDecoder =
    JPipeline.decode DocumentAttributes
        |> JPipeline.required "public" (Decode.bool)
        |> JPipeline.required "text_type" (Decode.string |> Decode.andThen decodeTextType)
        |> JPipeline.required "doc_type" (Decode.string |> Decode.andThen decodeDocType)
        |> JPipeline.required "level" (Decode.int)
        |> JPipeline.optional "archive" (Decode.string) "default"
        |> JPipeline.optional "version" (Decode.int) 0
        |> JPipeline.hardcoded Nothing


decodeDocType : String -> Decoder DocType
decodeDocType docTypeString =
    case docTypeString of
        "standard" ->
            Decode.succeed Standard

        "master" ->
            Decode.succeed Master

        _ ->
            Decode.fail <| "I don't know a docType named " ++ docTypeString


decodeTextType : String -> Decoder TextType
decodeTextType textTypeString =
    case textTypeString of
        "adoc" ->
            Decode.succeed Asciidoc

        "adoc_latex" ->
            Decode.succeed AsciidocLatex

        "plain" ->
            Decode.succeed Asciidoc

        "latex" ->
            Decode.succeed MiniLatex

        _ ->
            Decode.fail <| "I don't know a textType named " ++ textTypeString


decodeChild : Decoder Child
decodeChild =
    JPipeline.decode Child
        |> JPipeline.required "title" (Decode.string)
        |> JPipeline.required "level" (Decode.int)
        |> JPipeline.required "doc_identifier" (Decode.string)
        |> JPipeline.required "doc_id" (Decode.int)
        |> JPipeline.required "comment" (Decode.string)



-- send_resp(conn, :no_content, "")


decodeDeleteDocumentReply : Decoder String
decodeDeleteDocumentReply =
    Decode.field "no_content" Decode.string



{- DOCUMENT LIST DECODER -}


documentListDecoder : Decoder DocumentListRecord
documentListDecoder =
    decode
        DocumentListRecord
        |> required "documents" (Decode.list documentDecoder)



{- ENCODERS -}


encodeDocumentRecord : Document -> Encode.Value
encodeDocumentRecord document =
    Encode.object
        [ ( "document"
          , encodeDocument document
          )
        ]


encodeDocument : Document -> Encode.Value
encodeDocument document =
    Encode.object
        [ ( "title", Encode.string <| document.title )
        , ( "rendered_content", Encode.string <| document.renderedContent )
        , ( "id", Encode.int <| document.id )
        , ( "identifier", Encode.string <| document.identifier )
        , ( "content", Encode.string <| document.content )
        , ( "author_id", Encode.int <| document.authorId )
        , ( "attributes", encodeDocumentAttributes <| document.attributes )
        , ( "tags", Encode.list <| List.map Encode.string <| document.tags )
        , ( "parent_id", Encode.int <| document.parentId )
        , ( "parent_title", Encode.string <| document.parentTitle )
        ]


encodeDocumentAttributes : DocumentAttributes -> Encode.Value
encodeDocumentAttributes record =
    Encode.object
        [ ( "text_type", encodeTextType <| record.textType )
        , ( "public", Encode.bool <| record.public )
        , ( "doc_type", encodeDocType <| record.docType )
        , ( "level", Encode.int <| record.level )
        , ( "archive", Encode.string <| record.archive )
        , ( "version", Encode.int <| record.version )
        ]


encodeDocumentForOutside : Document -> Encode.Value
encodeDocumentForOutside document =
    let
        textType =
            document.attributes.textType

        content_to_render =
            case textType of
                MiniLatex ->
                    document.renderedContent

                _ ->
                    Document.Preprocess.preprocess document.content document
    in
        [ ( "id", Encode.int document.id )
        , ( "content", Encode.string content_to_render )
        , ( "textType", encodeTextType document.attributes.textType )
        ]
            |> Encode.object


encodeDocType : DocType -> Encode.Value
encodeDocType docType =
    case docType of
        Standard ->
            Encode.string "standard"

        Master ->
            Encode.string "master"


encodeTextType : TextType -> Encode.Value
encodeTextType textType =
    case textType of
        Asciidoc ->
            Encode.string "adoc"

        AsciidocLatex ->
            Encode.string "adoc_latex"

        MiniLatex ->
            Encode.string "latex"

        Plain ->
            Encode.string "plain"


encodeChild : Child -> Encode.Value
encodeChild record =
    Encode.object
        [ ( "title", Encode.string <| record.title )
        , ( "level", Encode.int <| record.level )
        , ( "doc_identifier", Encode.string <| record.docIdentifier )
        , ( "doc_id", Encode.int <| record.docId )
        , ( "comment", Encode.string <| record.comment )
        ]
