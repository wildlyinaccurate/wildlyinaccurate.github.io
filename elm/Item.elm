module Item
    exposing
        ( Item
        , view
        )

import Html exposing (..)
import Html.Attributes exposing (class, href)
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
            span [ Elm.Kernel.VirtualDom.property "innerHTML" (string item.description) ] []
                :: (List.map tagView item.tags)
        ]


tagView : String -> Html msg
tagView tag =
    span
        [ class "item-tag badge badge-primary" ]
        [ text tag ]
