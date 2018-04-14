module Document.Data exposing (..)

import Json.Encode as Encode exposing (..)
import Json.Decode as Decode exposing (at, int, list, string, decodeString, Decoder)
import Json.Decode.Pipeline as JPipeline exposing (decode, required, optional, hardcoded)
import Document.Model exposing (Document, DocumentRecord, DocumentAttributes, Child, DocumentListRecord)


{- DOCUMENT DECODERS -}


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


documentRecordDecoder : Decoder DocumentRecord
documentRecordDecoder =
    JPipeline.decode DocumentRecord
        |> JPipeline.required "document" (documentDecoder)


documentAttributesDecoder : Decoder DocumentAttributes
documentAttributesDecoder =
    JPipeline.decode DocumentAttributes
        |> JPipeline.required "public" (Decode.bool)
        |> JPipeline.required "text_type" (Decode.string)
        |> JPipeline.required "doc_type" (Decode.string)
        |> JPipeline.required "level" (Decode.int)
        |> JPipeline.optional "archive" (Decode.string) "default"
        |> JPipeline.optional "version" (Decode.int) 0
        |> JPipeline.hardcoded Nothing


decodeChild : Decoder Child
decodeChild =
    JPipeline.decode Child
        |> JPipeline.required "title" (Decode.string)
        |> JPipeline.required "level" (Decode.int)
        |> JPipeline.required "doc_identifier" (Decode.string)
        |> JPipeline.required "doc_id" (Decode.int)
        |> JPipeline.required "comment" (Decode.string)



{- DOCUMENT LIST DECODER -}


documentListDecoder : Decoder DocumentListRecord
documentListDecoder =
    decode
        DocumentListRecord
        |> required "documents" (Decode.list documentDecoder)



{- ENCODERS -}


encodeChild : Child -> Encode.Value
encodeChild record =
    Encode.object
        [ ( "title", Encode.string <| record.title )
        , ( "level", Encode.int <| record.level )
        , ( "doc_identifier", Encode.string <| record.docIdentifier )
        , ( "doc_id", Encode.int <| record.docId )
        , ( "comment", Encode.string <| record.comment )
        ]
