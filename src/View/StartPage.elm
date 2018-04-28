module View.StartPage exposing (view)

import Element exposing (image, textLayout, paragraph, el, paragraph, newTab, row, wrappedRow, column, button, text, empty)
import Element.Attributes exposing (..)
import Element.Input
import Element.Events exposing (onClick, onInput)
import Element.Keyed
import View.Stylesheet exposing (..)
import Html
import Model exposing (Model, Mode(..))
import Helper
import Msg
import User.Msg
    exposing
        ( UserMsg
            ( SignIn
            , AuthenticateUser
            , SignUpUser
            , CancelSignIn
            , GoToSignupForm
            , InputName
            , InputUsername
            , InputEmail
            , InputPassword
            , UserNoOp
            )
        )
import View.Widget as Widget
import View.Menubar as Menubar
import View.Footer as Footer
import View.Render as Render
import Document.Dictionary as Dictionary
import Document.Default


view model =
    Element.column Main
        []
        [ Menubar.view model
        , mainRow model
        , Footer.view model
        ]



{- MAIN -}


mainRow model =
    row Main
        [ height fill ]
        [ column Alternate [ width (fillPortion 30), height fill ] (leftColumn model)
        , column Main [ width (fillPortion 70), height fill, center, verticalCenter, spacing 40 ] (mainContent model)
        ]


mainContent model =
    case model.mode of
        Public ->
            startContent model

        SigningIn ->
            signInForm model

        SigningUp ->
            signUpForm model

        SignedIn ->
            signedInContent model



{- LEFT COLUMN -}


leftColumn model =
    [ row Alternate [] [ Render.renderedContent model (contentsWidth model) 70 model.currentDocument ]
    ]


contentsWidth model =
    model.windowWidth
        |> toFloat
        |> (\x -> Basics.max 300 (0.3 * x))
        |> px



{- MAIN COLUMN -}


startContent model =
    [ row Heading [ center ] [ text ("kNode: A place to share your knowledge") ]
    , row Main [ center ] [ mainImage ]
    ]


mainImage =
    image Main [ width (percent 100) ] { src = "http://noteshare-images.s3.amazonaws.com/crab_nebula_hubble.png", caption = "Kandinsky" }


usernameText model =
    case model.maybeCurrentUser of
        Just user ->
            "Signed in as " ++ user.username

        Nothing ->
            ""


signedInContent model =
    [ row Heading [ center ] [ text (usernameText model) ]
    , row Main [ center ] [ signedInMainImage ]
    ]


signedInMainImage =
    image Main [ width (percent 100) ] { src = "http://noteshare-images.s3.amazonaws.com/crab_nebula_hubble.png", caption = "Bubble chamber" }



--
-- https://www.physicsforums.com/attachments/collider-jpg.148712/
-- https://dg19s6hp6ufoh.cloudfront.net/pictures/613145863/large/Paul-Klee-Flora-on-sand.jpeg?1481352336
--
{- SIGN IN -}


signInForm model =
    [ column Panel
        [ width (px 400), height (px 500), paddingXY 20 20, center, spacing 20 ]
        [ row PanelHeading [ center ] [ text ("Sign in form") ]
        , row Panel [] [ Widget.inputField "Email" "" 300 (Msg.UserMsg << InputEmail) ]
        , row Panel [] [ Widget.passwordField "Password" "" 300 (Msg.UserMsg << InputPassword) ]
        , row Panel [] [ Widget.formButton "Sign in" 300 [ onClick (Msg.UserMsg AuthenticateUser) ] False ]
        , row Panel [] [ Widget.formButton "Cancel" 300 [ onClick (Msg.UserMsg CancelSignIn) ] False ]
        , row Panel [ paddingTop 40 ] [ Widget.formButton "Need to sign up instead?" 300 [ onClick (Msg.UserMsg GoToSignupForm) ] False ]
        ]
    ]


signUpForm model =
    [ column Panel
        [ width (px 400), height (px 500), paddingXY 20 20, center, spacing 20 ]
        [ row PanelHeading [ center ] [ text ("Sign up form") ]
        , row Panel [] [ Widget.inputField "Name" "" 300 (Msg.UserMsg << InputName) ]
        , row Panel [] [ Widget.inputField "Username" "" 300 (Msg.UserMsg << InputUsername) ]
        , row Panel [] [ Widget.inputField "Email" "" 300 (Msg.UserMsg << InputEmail) ]
        , row Panel [] [ Widget.passwordField "Password" "" 300 (Msg.UserMsg << InputPassword) ]
        , row Panel [] [ Widget.formButton "Sign up" 300 [ onClick (Msg.UserMsg SignUpUser) ] False ]
        , row Panel [] [ Widget.formButton "Cancel" 300 [ onClick (Msg.UserMsg CancelSignIn) ] False ]
        ]
    ]
