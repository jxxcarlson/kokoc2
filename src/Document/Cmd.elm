module Document.Cmd exposing (getDocuments)

import Api.Request
import Document.RequestParameters
import Msg exposing (Msg)


getDocuments : String -> String -> Cmd Msg
getDocuments token query =
    let
        route =
            "/public/documents?" ++ query
    in
        Api.Request.doRequest <| Document.RequestParameters.documents token route
