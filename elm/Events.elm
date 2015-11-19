module Events
  (onChange)
  where

import Html exposing (Attribute)
import Html.Events exposing (..)
import Signal exposing (..)


onChange : Address a -> (String -> a) -> Html.Attribute
onChange address f =
  on "change" targetValue (message (forwardTo address f))
