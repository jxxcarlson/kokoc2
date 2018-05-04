module Document.Utility
    exposing
        ( archiveName
        , wordCount
        , identifier
        , masterDocumenWordCount
        , hasId
        , replaceIf
        )

import Model exposing (Model)
import Document.Model exposing (Document)
import Array


concatenateText : List Document -> String
concatenateText documentList =
    documentList |> List.foldl (\doc acc -> acc ++ "\n\n" ++ doc.content) ""


masterDocumenWordCount : Model -> Int
masterDocumenWordCount model =
    List.drop 1 model.documentList
        |> concatenateText
        |> String.words
        |> List.length


wordCount : Document -> Int
wordCount document =
    document.content
        |> String.words
        |> List.length


archiveName : Model -> Document -> String
archiveName model document =
    let
        maybeParent =
            if model.maybeMasterDocument == Nothing then
                Nothing
            else
                List.head model.documentList

        parentArchiveName =
            case maybeParent of
                Just parent ->
                    parent.attributes.archive

                Nothing ->
                    "default"

        documentArchiveName =
            document.attributes.archive

        archiveName =
            if documentArchiveName /= "default" then
                documentArchiveName
            else if parentArchiveName /= "default" then
                parentArchiveName
            else
                "default"
    in
        archiveName


identifier : Document -> String
identifier document =
    let
        parts =
            String.split "." document.identifier |> Array.fromList

        datePart =
            Array.get 2 parts |> Maybe.withDefault "--"

        hashPart =
            Array.get 3 parts |> Maybe.withDefault "--"
    in
        datePart ++ "." ++ hashPart


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
