module Experiment exposing (..)

import Style exposing (Style)


type Foo
    = Foo_ (List String)


combine : Foo -> Foo -> Foo
combine x y =
    let
        xList =
            case x of
                Foo_ xList ->
                    xList

        yList =
            case y of
                Foo_ yList ->
                    yList
    in
        Foo_ <| xList ++ yList


type Bar
    = Bar_ String (List String)


combineBar : String -> Bar -> Bar -> Bar
combineBar newName x y =
    let
        xList =
            case x of
                Bar_ xName xList ->
                    xList

        yList =
            case y of
                Bar_ yName yList ->
                    yList
    in
        Bar_ newName (xList ++ yList)



--
-- combineStyles : Style -> Style -> Style
-- combineStyles x y name =
--     let
--         xList =
--             case x of
--                 Style xList ->
--                     xList
--
--         yList =
--             case y of
--                 Style yList ->
--                     yList
--     in
--         Style name (xList ++ yList)
