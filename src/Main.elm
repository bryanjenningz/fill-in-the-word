module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random exposing (Generator)
import Regex
import Set exposing (Set)
import Tuple
import Data exposing (TextTime, videoData)


type Msg
    = Time Float
    | Input String
    | GenerateIndexes
    | WordIndex Int


type alias Model =
    { time : Float
    , lines : List TextTime
    , line : TextTime
    , input : String
    , playing : Bool
    , wordIndexes : Set Int
    }


getLine : List TextTime -> Float -> TextTime
getLine lines time =
    let
        firstLine =
            case List.head lines of
                Just line ->
                    line

                Nothing ->
                    Debug.crash "You passed in an empty list of lines."
    in
        lines
            |> List.filter (\line -> line.time <= time)
            |> List.reverse
            |> List.head
            |> Maybe.withDefault firstLine


toHiddenLine : Set Int -> TextTime -> List TextTime -> TextTime
toHiddenLine wordIndexes line lines =
    lines
        |> List.map2 (,) (getWordOffsets lines)
        |> List.filter (Tuple.second >> (==) line)
        |> first
        |> Tuple.mapSecond toWords
        |> (\( offset, words ) ->
                List.range offset (offset + (List.length words - 1))
                    |> List.filter (\i -> Set.member i wordIndexes)
                    |> List.map (\i -> get (i - offset) words)
           )
        |> (\words -> TextTime (String.join " " words) line.time)


get : Int -> List a -> a
get index list =
    case list |> List.drop index |> List.head of
        Just element ->
            element

        Nothing ->
            Debug.crash "You tried to get an element that doesn't exist."


toWords : TextTime -> List String
toWords =
    .text >> String.split " "


wordCount : TextTime -> Int
wordCount =
    toWords >> List.length


getAllWords : List TextTime -> List String
getAllWords lines =
    lines
        |> List.map toWords
        |> List.concat


getWordOffsets : List TextTime -> List Int
getWordOffsets lines =
    lines
        |> List.map wordCount
        |> List.scanl (+) 0


randomWordIndexes : List TextTime -> List (Generator Int)
randomWordIndexes lines =
    lines
        |> List.map2 (,) (getWordOffsets lines)
        |> List.foldl
            (\( wordOffset, line ) indexes ->
                (Random.int
                    wordOffset
                    (wordOffset + wordCount line - 1)
                )
                    :: indexes
            )
            []


shouldPause : String -> TextTime -> Float -> Bool
shouldPause input textTime time =
    textTime.time + 5 < time && input /= textTime.text


removeNonAlpha : String -> String
removeNonAlpha =
    Regex.replace Regex.All (Regex.regex "[^a-zA-Z]") (\_ -> "")


first : List a -> a
first list =
    case List.head list of
        Just head ->
            head

        Nothing ->
            Debug.crash "Your list needs to be non-empty"


init : ( Model, Cmd Msg )
init =
    ( Model 0 videoData.lines (first videoData.lines) "" False Set.empty
    , Cmd.none
    )


view : Model -> Html Msg
view model =
    div []
        [ text (toString model) ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Time time ->
            ( { model | time = time }, Cmd.none )

        Input input ->
            if String.startsWith input (removeNonAlpha model.line.text) then
                ( { model | input = input }, Cmd.none )
            else
                ( model, Cmd.none )

        GenerateIndexes ->
            ( model
            , Cmd.batch
                (List.map
                    (Random.generate WordIndex)
                    (randomWordIndexes model.lines)
                )
            )

        WordIndex wordIndex ->
            ( { model | wordIndexes = Set.insert wordIndex model.wordIndexes }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
