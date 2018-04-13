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
    exposing
        ( Msg(UserMsg)
        , UserMsg
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
import View.Text as Text


view model =
    Element.column Main
        [ width <| px <| toFloat <| model.windowWidth, height <| px <| toFloat <| model.windowHeight ]
        [ Widget.menubar model (menuContent model)
        , mainRow model
        , Widget.footer model footerContent
        ]



{- MAIN -}


mainRow model =
    row Main
        [ height fill ]
        [ column Alternate [ width (fillPortion 30), height fill, paddingTop 30, spacing 15 ] (leftColumn model)
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
    [ row LeftHeading [ paddingLeft 40 ] [ text ("About kNode") ]
    , row Alternate [ paddingLeft 40 ] (textColumn model)
    ]


textColumn model =
    [ textLayout Alternate [ yScrollbar, height (px <| toFloat <| model.windowHeight - 160), spacing 10 ] (textContent model) ]


textContent model =
    Text.loremIpsum |> Text.paragraphify (\x -> paragraph Alternate [ width (px ((Helper.leftColumnWidth model) - 120)) ] [ text x ])



{- MAIN COLUMN -}


startContent model =
    [ row Heading [ center ] [ text ("kNode: A place to share your knowledge") ]
    , row Main [ center ] [ mainImage ]
    ]


mainImage =
    image Main [ width (percent 80) ] { src = "https://www.ibiblio.org/wm/paint/auth/kandinsky/kandinsky.comp-8.jpg", caption = "Kandinsky" }


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
    image Main [ width (percent 80) ] { src = "https://dg19s6hp6ufoh.cloudfront.net/pictures/613145863/large/Paul-Klee-Flora-on-sand.jpeg?1481352336", caption = "Kandinsky" }



{- SIGN IN -}


signInForm model =
    [ column Panel
        [ width (px 400), height (px 500), paddingXY 20 20, center, spacing 20 ]
        [ row PanelHeading [ center ] [ text ("Sign in form") ]
        , row Panel [] [ Widget.inputField "Email" "" 300 (UserMsg << InputEmail) ]
        , row Panel [] [ Widget.passwordField "Password" "" 300 (UserMsg << InputPassword) ]
        , row Panel [] [ Widget.formButton "Sign in" 300 [ onClick (UserMsg AuthenticateUser) ] False ]
        , row Panel [] [ Widget.formButton "Cancel" 300 [ onClick (UserMsg CancelSignIn) ] False ]
        , row Panel [ paddingTop 40 ] [ Widget.formButton "Need to sign up instead?" 300 [ onClick (UserMsg GoToSignupForm) ] False ]
        ]
    ]


signUpForm model =
    [ column Panel
        [ width (px 400), height (px 500), paddingXY 20 20, center, spacing 20 ]
        [ row PanelHeading [ center ] [ text ("Sign up form") ]
        , row Panel [] [ Widget.inputField "Name" "" 300 (UserMsg << InputName) ]
        , row Panel [] [ Widget.inputField "Username" "" 300 (UserMsg << InputUsername) ]
        , row Panel [] [ Widget.inputField "Email" "" 300 (UserMsg << InputEmail) ]
        , row Panel [] [ Widget.passwordField "Password" "" 300 (UserMsg << InputPassword) ]
        , row Panel [] [ Widget.formButton "Sign up" 300 [ onClick (UserMsg SignUpUser) ] False ]
        , row Panel [] [ Widget.formButton "Cancel" 300 [ onClick (UserMsg CancelSignIn) ] False ]
        ]
    ]



{- MENU -}


menuContent model =
    [ leftMenu, centerMenu, rightMenu model ]


leftMenu =
    row Menubar [ alignLeft, width (fillPortion 33), paddingLeft 20 ] [ el Menubar [ verticalCenter, paddingLeft 20, paddingRight 20 ] (text "Yo!  ") ]


centerMenu =
    row Menubar [ center, width (fillPortion 35) ] [ el Menubar [ verticalCenter, paddingLeft 20, paddingRight 20 ] (text "Welcome!  ") ]


rightMenu model =
    row Menubar [ alignRight, width (fillPortion 33), paddingRight 20 ] [ Widget.button (signInButtonLabel model) 75 [ onClick (UserMsg SignIn) ] False ]


signInButtonLabel model =
    if model.mode == SignedIn then
        "Sign out"
    else
        "Sign in"



{- FOOTER -}


footerContent =
    [ el Menubar [ verticalCenter, paddingLeft 20, paddingRight 20 ] (text "Start Page Footer")
    ]
