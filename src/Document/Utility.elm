module Document.Utility exposing (archiveName)

import Model exposing (Model)
import Document.Model exposing (Document)


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
