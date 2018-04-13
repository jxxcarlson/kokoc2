module Helper exposing (..)

import Model exposing (Model)


effectiveWindowHeight model =
    toFloat <| model.windowHeight - 160


leftColumnWidth model =
    0.33 * (toFloat <| model.windowWidth)
