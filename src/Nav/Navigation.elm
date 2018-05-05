module Nav.Navigation exposing (navigateTo, setPublicUrlWithId, setUrl)

import Document.Cmd
import Model exposing (Model, Page(..))
import Msg exposing (Msg)
import Document.Model exposing (DocumentAccessibility(..))
import Configuration
import Navigation
import Document.Model exposing (Document)


startPage model =
    ( { model | page = StartPage }
    , Cmd.batch
        [ -- Navigation.newUrl (Configuration.client ++ "/##public/181")
          Document.Cmd.searchWithQueryCmd model Document.Model.PublicDocument "id=181"
        ]
    )


setPublicUrlWithId : Int -> Cmd Msg
setPublicUrlWithId id =
    Navigation.newUrl (Configuration.client ++ "/##public/" ++ (toString id))


setUrl : Document -> Cmd Msg
setUrl document =
    if document.attributes.public then
        Navigation.newUrl (Configuration.client ++ "/##public/" ++ (toString document.id))
    else
        Navigation.newUrl (Configuration.client ++ "/##document/" ++ (toString document.id))


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
                        case k of
                            0 ->
                                startPage model

                            181 ->
                                startPage model

                            _ ->
                                ( { model | page = ReaderPage }, Document.Cmd.searchWithQueryCmd model Document.Model.PublicDocument ("id=" ++ toString k) )

                    _ ->
                        startPage model
