module Main exposing (..)

import Collection exposing (Collection, init, subscriptions, update, view)
import Browser


main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
