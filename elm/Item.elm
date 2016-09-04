module Item
    exposing
        ( Item
        , view
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Encode exposing (string)


type alias Item =
    { title : String
    , description : String
    , url : String
    , tags : List String
    , category : String
    }


view : Item -> Html msg
view item =
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
                :: (List.map tagView item.tags)
        ]


tagView : String -> Html msg
tagView tag =
    span
        [ class "item-tag label label-default" ]
        [ text tag ]
