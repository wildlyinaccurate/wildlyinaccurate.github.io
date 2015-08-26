module Collection
    ( Collection
    , model
    , update
    , view
    ) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetChecked)
import Html.Lazy exposing (lazy2)
import Signal exposing (Signal, Address)

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
    let intersect = LE.intersect filters item.tags
    in
        not (List.isEmpty intersect)


---- MODEL ----

type alias Collection =
    { items : ItemList
    , filters : FilterList
    }


type alias ItemList = List Item.Item


type alias FilterList = List String


model : Maybe Collection -> Collection
model fixtures =
    case fixtures of
        Just f ->
            { f | filters <- allTags f }

        Nothing ->
            emptyModel


emptyModel : Collection
emptyModel =
    Collection [] []


---- UPDATE ----

type Action
    = SelectFilter String Bool
    | SelectAllFilters Bool


update : Action -> Collection -> Collection
update action model =
    case action of
        SelectFilter tag checked ->
            if checked then
                { model | filters <- tag :: model.filters }
            else
                { model | filters <- List.filter ((/=) tag) model.filters }

        SelectAllFilters checked ->
            if checked then
                { model | filters <- allTags model }
            else
                { model | filters <- [] }


---- VIEW ----

view : Address Action -> Collection -> Html
view address model =
    let filteredItems = filterItems model.filters model.items
    in
        div
            []
            [ lazy2 filterControls address model
            , lazy2 itemList address filteredItems
            ]


itemList : Address Action -> ItemList -> Html
itemList address items =
    div [] (List.map (Item.view address) items)


filterControls : Address Action -> Collection -> Html
filterControls address model =
    let tags = allTags model
        filters = model.filters
        allChecked = (filters == tags)
    in
        div
            []
            [ h4
                []
                [ text "Filters" ]

            , ul
                [ class "filters" ]
                ( selectAll address allChecked :: tagFilters address filters tags )
            ]


selectAll : Address Action -> Bool -> Html
selectAll address allChecked =
    li
        [ class "filter filter--select-all"]
        [ checkbox address allChecked SelectAllFilters "All" ]


tagFilters : Address Action -> FilterList -> List String -> List Html
tagFilters address filters tags =
    List.map (tagFilter address filters) tags


tagFilter : Address Action -> FilterList -> String -> Html
tagFilter address filters tag =
    let checked = List.member tag filters
    in
        li
            [ class "filter" ]
            [ checkbox address checked (SelectFilter tag) tag ]

checkbox : Address Action -> Bool -> (Bool -> Action) -> String -> Html
checkbox address isChecked action name =
    label
        [ class "btn btn-default btn-sm" ]
        [ input
            [ type' "checkbox"
            , checked isChecked
            , on "change" targetChecked (Signal.message address << action)
            ]
            []
            , text name
        ]
