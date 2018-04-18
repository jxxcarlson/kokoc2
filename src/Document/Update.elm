module Document.Update exposing (..)

import Model exposing (Model, Page(..))
import Msg exposing (Msg)
import Document.Msg exposing (..)
import Document.ActionRead as ActionRead
import Document.Model exposing (Document)
import Document.Cmd
import Api.Error as Error
import Utility


update : DocumentMsg -> Model -> ( Model, Cmd Msg )
update submessage model =
    let
        token =
            case model.maybeCurrentUser of
                Nothing ->
                    ""

                Just user ->
                    user.token
    in
        case submessage of
            GetDocumentList result ->
                ActionRead.getDocuments result model

            LoadContent (Ok documentRecord) ->
                ( ActionRead.loadContent model documentRecord, Cmd.none )

            LoadContent (Err error) ->
                ( { model | message = "LC: " ++ Error.httpErrorString error }, Cmd.none )

            LoadContentAndRender (Ok documentRecord) ->
                ( ActionRead.loadContent model documentRecord, Document.Cmd.putTextToRender documentRecord.document )

            LoadContentAndRender (Err error) ->
                ( { model | message = "LCAR:" ++ Error.httpErrorString error }, Cmd.none )

            LoadParent ->
                ActionRead.loadParentDocument model

            SelectDocument document ->
                ( { model
                    | currentDocument = document
                    , masterDocLoaded = masterDocLoaded model document
                    , masterDocumentId = masterDocumentId model document
                    , masterDocumentTitle = masterDocumentTitle model document
                  }
                , Document.Cmd.selectMasterOrRender model document
                )

            InputSearchQuery str ->
                ( { model | searchQuery = str }, Cmd.none )

            SearchOnKey keyCode ->
                if keyCode == 13 then
                    ( { model
                        | page = Utility.setPage model
                        , masterDocLoaded = False
                        , masterDocumentId = 0
                        , masterDocumentTitle = ""
                      }
                    , Document.Cmd.search model
                    )
                else
                    ( model, Cmd.none )



{- HELPERS -}


masterDocLoaded : Model -> Document -> Bool
masterDocLoaded model document =
    if document.attributes.docType == "master" then
        True
    else if model.masterDocumentId > 0 && document.parentId == model.masterDocumentId then
        True
    else
        False


masterDocumentId : Model -> Document -> Int
masterDocumentId model document =
    if document.attributes.docType == "master" then
        document.id
    else if model.masterDocumentId > 0 && document.parentId == model.masterDocumentId then
        model.masterDocumentId
    else
        0


masterDocumentTitle : Model -> Document -> String
masterDocumentTitle model document =
    if document.attributes.docType == "master" then
        document.title
    else if model.masterDocumentId > 0 && document.parentId == model.masterDocumentId then
        model.masterDocumentTitle
    else
        ""
