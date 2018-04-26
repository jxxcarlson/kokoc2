module Document.MasterDocument
    exposing
        ( prepareExportLatexFromMaster
        , wordCount
        )

import Document.MiniLatex
import MiniLatex.FastExportToLatex as FastExportToLatex
import MiniLatex.RenderLatexForExport
import MiniLatex.Source as Source
import Request.Document
import Task
import Utility.KeyValue as KeyValue


concatenateText : List Document -> String
concatenateText documentList =
    documentList |> List.foldl (\doc acc -> acc ++ "\n\n" ++ doc.content) ""


wordCount : Model -> Int
wordCount model =
    List.drop 1 model.documents
        |> concatenateText
        |> String.words
        |> List.length


prepareExportLatexFromMaster : Model -> ( Model, Cmd Msg )
prepareExportLatexFromMaster model =
    let
        macroDefinitions =
            Document.MiniLatex.macros model.documentDict

        sourceText =
            List.drop 1 model.documents
                |> concatenateText
                |> FastExportToLatex.export

        -- |> FastExportToLatex.renderLatexForExport
        maybeAuthor =
            KeyValue.getStringValueForKeyFromTagList "author" model.current_document.tags

        maybeDate =
            KeyValue.getStringValueForKeyFromTagList "date" model.current_document.tags

        titleCommand =
            "\\title{" ++ model.current_document.title ++ "}"

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
