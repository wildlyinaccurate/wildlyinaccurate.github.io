module Main exposing (..)

import Collection exposing (Collection, model, subscriptions, update, view)
import Html as App


main =
    App.programWithFlags
        { init = model
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
