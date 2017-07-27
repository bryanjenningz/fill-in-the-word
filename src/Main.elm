module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random exposing (Generator)
import Data exposing (TextTime, videoData)


type Msg
    = Time Float


type alias Model =
    { time : Float
    , lines : List TextTime
    , input : String
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


toWords : TextTime -> List String
toWords =
    .text >> String.split " "


getAllWords : List TextTime -> List String
getAllWords lines =
    lines
        |> List.map toWords
        |> List.concat


getWordOffsets : List TextTime -> List Int
getWordOffsets lines =
    lines
        |> List.map (toWords >> List.length)
        |> List.scanl (+) 0


randomWordIndexes : List TextTime -> List (Generator Int)
randomWordIndexes lines =
    lines
        |> List.map2 (,) (getWordOffsets lines)
        |> List.foldl
            (\( wordOffset, line ) indexes ->
                (Random.int
                    wordOffset
                    (wordOffset + (toWords >> List.length) line - 1)
                )
                    :: indexes
            )
            []


shouldPause : String -> TextTime -> Float -> Bool
shouldPause input textTime time =
    textTime.time + 5 < time && input /= textTime.text


init : ( Model, Cmd Msg )
init =
    ( Model 0 videoData.lines "", Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ text (toString model) ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Time time ->
            ( { model | time = time }, Cmd.none )


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
