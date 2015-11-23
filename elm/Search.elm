module Search where

import List exposing (filterMap, map)
import Regex exposing (caseInsensitive, regex)
import String exposing (concat, trim)

import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (class, href, placeholder, value)
import Html.Events exposing (on, targetValue)
import Json.Decode as Json
import Signal exposing (Signal, Address)
import StartApp exposing (start)


app =
  start
    { init = init
    , update = update
    , view = view
    , inputs = []
    }


main =
    app.html


init : (Model, Effects Action)
init =
    ( model getSearchData
    , Effects.none
    )


port getSearchData : Maybe SearchData


---- MODEL ----

type alias Model =
    { query : String
    , results : List SearchResult
    , data : SearchData
    }


type alias SearchResult =
    { title : String
    , url : String
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


getResults : Model -> List SearchResult
getResults model =
    let
        fp = filterMap (postToResult model.query)
        ft = filterMap (stringToResult model.query "tag")
        fc = filterMap (stringToResult model.query "category")
        md = model.data
    in
        List.concat
            [ fp md.posts
            , ft md.tags
            , fc md.categories
            ]


stringToResult : String -> String -> String -> Maybe SearchResult
stringToResult query type' item =
    if matchString query item then
        Just <| SearchResult (concat [type', ": ", item]) (concat ["/", type', "/", item, "/"])

    else
        Nothing


postToResult : String -> Post -> Maybe SearchResult
postToResult query post =
    if (matchString query post.title) then
        Just <| SearchResult post.title post.url

    else
        Nothing


matchString : String -> String -> Bool
matchString needle haystack =
    Regex.contains (caseInsensitive (regex needle)) haystack


---- UPDATE ----

type Action
    = UpdateQuery String
    | UpdateResults


update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        UpdateQuery query ->
            ( { model | query = query }
            --, Effects.task UpdateResults
            , Effects.none
            )

        UpdateResults ->
            if String.length (trim model.query) == 0 then
                ( model
                , Effects.none
                )

            else
                ( { model | results = getResults model }
                , Effects.none
                )


---- VIEW ----

view : Address Action -> Model -> Html
view address model =
    div
        []
        [ searchInput address model
        , searchResults model
        ]


searchInput address model =
    input
        [ class "search-input"
        , value model.query
        , placeholder "Enter query to search"
        , on "input" targetValue (Signal.message address << UpdateQuery)
        ]
        []


searchResults model =
    div
        [ class "search-results" ]
        [ resultsTitle model
        , ul
            [ class "search-results__results" ]
            (map searchResult model.results)
        ]


searchResult result =
    li
        [ class "result-item" ]
        [ h4
            [ class "result-item__title" ]
            [ a
                [ class "result-item__link"
                , href result.url
                ]
                [ text result.title ]
            ]
        ]


resultsTitle model =
    if List.length model.results == 0 then
        if String.length (trim model.query) > 0 then
            h2
                [ class "search-results__title" ]
                [ text
                    <| concat [ "No results found for '", model.query, "'" ]
                ]
        else
            span [] []
    else
        h2
            [ class "search-results__title" ]
            [ text
                <| concat [ "Search results for '", model.query, "'" ]
            ]

