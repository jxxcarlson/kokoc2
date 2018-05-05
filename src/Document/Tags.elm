module Document.Tags exposing (updateTags)

import Model exposing (Model)
import Document.Model exposing (Document)


parseTagString : String -> List String
parseTagString str =
    String.split "," str
        |> List.map String.trim


updateTags : Document -> String -> Document
updateTags document tagText =
    { document | tags = (parseTagString tagText) }
