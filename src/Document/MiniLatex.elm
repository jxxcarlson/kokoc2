module Document.MiniLatex exposing (getMacroDefinitions, macros)


getMacroDefinitions : Model -> String
getMacroDefinitions model =
    let
        macrosString =
            macros model.documentDict |> (\x -> "\n$$\n" ++ String.trim x ++ "\n$$\n")
    in
        macrosString ++ "\n\n$$\n\\newcommand{\\label}[1]{}" ++ "\n$$\n\n"


macros : Dict String Document -> String
macros documentDict =
    if Dictionary.member "texmacros" documentDict then
        Dictionary.getContent "texmacros" documentDict
            |> Regex.replace Regex.All (Regex.regex "\n+") (\_ -> "\n")
    else
        ""
