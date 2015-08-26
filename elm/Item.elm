module Item
    ( Item
    , view
    ) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Signal exposing (Address)
import Json.Encode exposing (string)


type alias Item =
    { title : String
    , description : String
    , url : String
    , tags : List String
    , category : String
    }


view : Address a -> Item -> Html
view address item =
    div
        []
        [ h4
            []
            [ a
                [ href item.url ]
                [ text item.title ]
            ]
        , p [] <|
            span [ property "innerHTML" (Json.Encode.string item.description) ] []
            :: (List.map (tagView address) item.tags)
        ]


tagView : Address a -> String -> Html
tagView address tag =
    span
        [ class "item-tag label label-default" ]
        [ text tag ]
