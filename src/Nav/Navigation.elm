module Nav.Navigation exposing (navigateTo)

import Document.Cmd
import Model exposing (Model, Page(..))
import Msg exposing (Msg)


navigateTo : Maybe Page -> Model -> ( Model, Cmd Msg )
navigateTo maybepage model =
    let
        _ =
            Debug.log "MAYBEPAGE" maybepage
    in
        case maybepage of
            Nothing ->
                ( model, Cmd.none )

            Just page ->
                case page of
                    UrlPage k ->
                        ( { model | page = ReaderPage }, Document.Cmd.searchWithQueryCmd model ("id=" ++ toString k) )

                    _ ->
                        ( model, Cmd.none )
