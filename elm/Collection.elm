module Collection
    exposing
        ( Collection
        , model
        , subscriptions
        , update
        , view
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onCheck, targetChecked)
import Html.Lazy exposing (lazy)
import Item
import List.Extra as LE


---- UTILS ----


allTags : Collection -> List String
allTags model =
    (uniqueProperties .tags) model.items


uniqueProperties : (a -> List comparable) -> List a -> List comparable
uniqueProperties property =
    List.map property >> List.concat >> LE.nub


filterItems : FilterList -> ItemList -> ItemList
filterItems filters items =
    List.filter (matchesFilters filters) items


matchesFilters : FilterList -> Item.Item -> Bool
matchesFilters filters item =
    let
        intersect =
            LE.intersect filters item.tags
    in
        not (List.isEmpty intersect)



---- MODEL ----


type alias Collection =
    { items : ItemList
    , filters : FilterList
    }


type alias ItemList =
    List Item.Item


type alias FilterList =
    List String


model : Maybe Collection -> ( Collection, Cmd msg )
model fixtures =
    case fixtures of
        Just f ->
            ( { f | filters = allTags f }, Cmd.none )

        Nothing ->
            ( emptyModel, Cmd.none )


emptyModel : Collection
emptyModel =
    Collection [] []



---- SUBSCRIPTIONS ----


subscriptions : Collection -> Sub Msg
subscriptions model =
    Sub.none



---- UPDATE ----


type Msg
    = SelectFilter String Bool
    | SelectAllFilters Bool


update : Msg -> Collection -> ( Collection, Cmd msg )
update action model =
    let
        updatedModel =
            case action of
                SelectFilter tag checked ->
                    if checked then
                        { model | filters = tag :: model.filters }
                    else
                        { model | filters = List.filter ((/=) tag) model.filters }

                SelectAllFilters checked ->
                    if checked then
                        { model | filters = allTags model }
                    else
                        { model | filters = [] }
    in
        ( updatedModel, Cmd.none )



---- VIEW ----


view : Collection -> Html Msg
view model =
    let
        filteredItems =
            filterItems model.filters model.items
    in
        div
            []
            [ lazy filterControls model
            , lazy itemList filteredItems
            ]


itemList : ItemList -> Html Msg
itemList items =
    div [] (List.map Item.view items)


filterControls : Collection -> Html Msg
filterControls model =
    let
        tags =
            allTags model

        filters =
            model.filters

        allChecked =
            (filters == tags)
    in
        div
            []
            [ h4
                []
                [ text "Filters" ]
            , ul
                [ class "filters" ]
                (selectAll allChecked :: tagFilters filters tags)
            ]


selectAll : Bool -> Html Msg
selectAll allChecked =
    li
        [ class "filter filter--select-all" ]
        [ checkbox allChecked SelectAllFilters "All" ]


tagFilters : FilterList -> List String -> List (Html Msg)
tagFilters filters tags =
    List.map (tagFilter filters) tags


tagFilter : FilterList -> String -> Html Msg
tagFilter filters tag =
    let
        checked =
            List.member tag filters
    in
        li
            [ class "filter" ]
            [ checkbox
                checked
                (SelectFilter tag)
                tag
            ]


checkbox : Bool -> (Bool -> Msg) -> String -> Html Msg
checkbox isChecked action name =
    label
        [ class "btn btn-default btn-sm" ]
        [ input
            [ type' "checkbox"
            , checked isChecked
            , onCheck action
            ]
            []
        , text name
        ]
