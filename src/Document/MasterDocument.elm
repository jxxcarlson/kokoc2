module Document.MasterDocument
    exposing
        ( prepareExportLatexFromMaster
        , wordCount
        )

import Document.MeenyLatex
import MeenyLatex.FastExportToLatex as FastExportToLatex
import MeenyLatex.RenderLatexForExport
import MeenyLatex.Source as Source
import Model exposing (Model)
import Document.Dictionary as Dictionary
import Regex
import Document.Model exposing (Document)
import Msg exposing (Msg)
import Task
import Utility.KeyValue as KeyValue


concatenateText : List Document -> String
concatenateText documentList =
    documentList |> List.foldl (\doc acc -> acc ++ "\n\n" ++ doc.content) ""


wordCount : Model -> Int
wordCount model =
    List.drop 1 model.documentList
        |> concatenateText
        |> String.words
        |> List.length


prepareExportLatexFromMaster : Model -> ( Model, Cmd Msg )
prepareExportLatexFromMaster model =
    let
        macroDefinitions =
            Document.MeenyLatex.macros model.documentDict

        sourceText =
            List.drop 1 model.documentList
                |> concatenateText
                |> FastExportToLatex.export

        maybeAuthor =
            KeyValue.getStringValueForKeyFromTagList "author" model.currentDocument.tags

        maybeDate =
            KeyValue.getStringValueForKeyFromTagList "date" model.currentDocument.tags

        titleCommand =
            "\\title{" ++ model.currentDocument.title ++ "}"

        authorCommand =
            case maybeAuthor of
                Just author ->
                    "\\author{" ++ author ++ "}"

                Nothing ->
                    ""

        dateCommand =
            case maybeDate of
                Just date ->
                    "\\date{" ++ date ++ "}"

                Nothing ->
                    ""

        commands =
            [ titleCommand, authorCommand, dateCommand, "\\maketitle", "\\tableofcontents" ] |> String.join ("\n")

        textToExport =
            Source.texPrefix ++ "\n\n" ++ macroDefinitions ++ "\n\n" ++ commands ++ "\n\n" ++ sourceText ++ "\n\n" ++ Source.texSuffix
    in
        ( { model | textToExport = textToExport }, Cmd.none )
