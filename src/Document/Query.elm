module Document.Query exposing (makeQuery)

import Document.QueryParser exposing (parseQuery)
import Http
import Document.Model
    exposing
        ( SearchDomain(..)
        , SortOrder(..)
        )


makeQuery : SearchDomain -> SortOrder -> Int -> String -> String
makeQuery searchDomain searchOrder userId rawQuery =
    let
        cmd =
            rawQuery |> String.split "=" |> List.head |> Maybe.withDefault "NoCommand"
    in
        if List.member cmd [ "idlist" ] then
            rawQuery
        else
            makeQueryHelper searchDomain searchOrder userId rawQuery


cleanQuery : String -> String
cleanQuery query =
    String.split "&" query
        |> List.filter (\item -> not (String.contains "random" item))
        |> String.join "&"


fixQueryIfEmpty : String -> SearchDomain -> Int -> String
fixQueryIfEmpty query searchDomain userId =
    if query == "" then
        case searchDomain of
            SearchPublic ->
                "random=public"

            SearchPrivate ->
                "random_user=" ++ toString userId

            SearchShared ->
                "random_user=" ++ toString userId

            SearchAll ->
                "random=all"
    else
        query


makeQueryHelper : SearchDomain -> SortOrder -> Int -> String -> String
makeQueryHelper searchDomain searchOrder userId queryString =
    let
        queryList =
            [ queryPrefix userId searchDomain queryString
            , parseQuery queryString
            , searchOrderQuery searchOrder
            , querySuffix searchDomain
            ]
    in
        (buildQuery queryList) ++ "&loading"


queryPrefix : Int -> SearchDomain -> String -> String
queryPrefix userId searchDomain queryString =
    case ( searchDomain, queryString ) of
        ( SearchAll, "" ) ->
            "random=all"

        ( SearchPublic, "" ) ->
            "random=public"

        ( SearchPrivate, "" ) ->
            "random_user=" ++ toString userId

        ( SearchAll, _ ) ->
            "docs=any"

        ( _, _ ) ->
            ""


querySuffix : SearchDomain -> String
querySuffix searchDomain =
    case searchDomain of
        SearchPrivate ->
            ""

        SearchShared ->
            "shared_only=yes"

        SearchPublic ->
            ""

        SearchAll ->
            ""


searchOrderQuery : SortOrder -> String
searchOrderQuery searchOrder =
    case searchOrder of
        ViewedOrder ->
            "sort=viewed"

        UpdatedOrder ->
            "sort=updated"

        CreatedOrder ->
            "sort=created"

        AlphabeticalOrder ->
            "sort=title"


buildQuery : List String -> String
buildQuery queryParts =
    queryParts
        |> List.filter (\x -> x /= "")
        |> String.join "&"



{- STUFF -}
-- processorAndRoute : SearchDomain -> ( Result Http.Error Types.DocumentsRecord -> DocMsg, String )
-- processorAndRoute searchDomain =
--     case searchDomain of
--         SearchPublic ->
--             ( GetDocuments, "public/documents" )
--
--         SearchPrivate ->
--             ( GetUserDocuments, "documents" )
--
--         SearchShared ->
--             ( GetUserDocuments, "documents" )
--
--         SearchAll ->
--             ( GetUserDocuments, "documents" )
