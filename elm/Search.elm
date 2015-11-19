module Search where

import String exposing (concat)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onKeyUp)
import Signal exposing (Signal, Address)
import StartApp.Simple exposing (start)


main =
  start
    { model = model getSearchData
    , update = update
    , view = view
    }


port getSearchData : Maybe SearchData


---- MODEL ----

type alias Model =
    { query : String
    , results : List Result
    , data : SearchData
    }


type alias Result =
    { title : String
    , url : String
    , type' : String
    }


type alias SearchData =
    { posts : List Post
    , categories : List String
    , tags : List String
    }


type alias Post =
    { title : String
    , url : String
    , categories : List String
    , tags : List String
    }


model : Maybe SearchData -> Model
model searchData =
    case searchData of
        Just data ->
            Model "" [] data

        Nothing ->
            emptyModel


emptyModel : Model
emptyModel =
    Model "" [] (SearchData [] [] [])


getResults : Model -> List Result
getResults model =
    []


---- UPDATE ----

type Action
    = Search String


update : Action -> Model -> Model
update action model =
    case action of
        Search query ->
            { model | query = query }


---- VIEW ----

view : Address Action -> Model -> Html
view address model =
    div
        []
        [ searchInput address model
        , searchResults model ]


searchInput address model =
    input
        [ class "search-input"
        , value model.query
        , placeholder "Enter query to search"
        , onKeyUp address (\_ -> Search) ]
        []


searchResults model =
    div
        [ class "search-results" ]
        [ resultsTitle model
        , ul
            [ class "search-results__results" ]
            (List.map searchResult model.results)
        ]


resultsTitle model =
    let
        resultsCount = List.length model.results
    in
        if resultsCount == 0 then
            if String.length model.query > 0 then
                h2
                    [ class "search-results__title" ]
                    [ text
                        <| concat ["No results found for '", model.query, "'"]
                    ]
            else
                span [] []
        else
            h2
                [ class "search-results__title" ]
                [ text
                    <| concat [(toString resultsCount), " results for '", model.query, "'"]
                ]


searchResult result =
    li
        [ class "result-item" ]
        []
