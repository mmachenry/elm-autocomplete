module Autocomplete exposing (
    State,
    Config,
    init,
    inputHtml,
    subscriptions,
    getValue)

import Browser.Events
import Html exposing (..)
import Html.Attributes exposing (style, id, placeholder, class, value, type_)
import Html.Events exposing (onInput, keyCode)
import Json.Decode as Decode
import List.Extra exposing (getAt)

type alias Config msg = {
    updateMessage : State -> msg,
    match : (String -> List String),
    inputAttributes : List (Html.Attribute msg)
    }

type alias State = {
    query : String,
    showOptions : Bool,
    activeOption : Maybe Int,
    options : List String
    }

init = {
    query = "",
    showOptions = False,
    activeOption = Nothing,
    options = []
    }

subscriptions : State -> Config msg -> Sub msg
subscriptions state config =
    Browser.Events.onKeyDown
        (Decode.map (key config state >> config.updateMessage) keyCode)

key : Config msg -> State -> Int -> State
key config state code = case code of
    40 -> -- Down
        let numOptions = List.length state.options
        in case state.activeOption of
              Just i ->
                  let nextOption = if i+1 >= numOptions then 0 else i+1
                  in { state | activeOption = Just nextOption}
              Nothing -> { state | activeOption = Just 0}
    38 -> -- Up
        let numOptions = List.length state.options
        in case state.activeOption of
              Just i ->
                  let nextOption = if i-1 < 0 then numOptions-1 else i-1
                  in { state | activeOption = Just nextOption}
              Nothing ->
                  { state | activeOption = Just (numOptions-1)}
    13 -> -- Enter
      case state.activeOption of
        Nothing -> state
        Just i ->
          case getAt i state.options of
            Nothing -> state
            Just str -> {state | showOptions = False, query = str}
    _ -> state

getValue : State -> String
getValue state = state.query

inputHtml : Config msg -> State -> Html msg
inputHtml config state =
    div [style "position" "relative",
         style "display" "inline-block"] [
        input ([onInput (onQueryInput state config >> config.updateMessage),
                value state.query]++config.inputAttributes) [],
        if state.showOptions
        then itemsHtml config state
        else Html.text ""
        ]

onQueryInput : State -> Config msg -> String -> State
onQueryInput state config newQuery = { state |
    query = newQuery,
    showOptions = String.length newQuery > 0,
    activeOption = Nothing,
    options = config.match newQuery
    }

itemsHtml : Config msg -> State -> Html msg
itemsHtml config state =
    div [style "position" "absolute",
         style "border" "1px solid #d4d4d4",
         style "border-bottom" "none",
         style "z-index" "99",
         style "top" "100%",
         style "left" "0",
         style "right" "0"]
        (List.indexedMap
            (itemHtml config state)
            state.options)

itemHtml : Config msg -> State -> Int -> String -> Html msg
itemHtml config state thisIndex name =
    let isActive = case state.activeOption of
                     Just i -> thisIndex == i
                     Nothing -> False
    in div [style "padding" "10px",
            style "cursor" "pointer",
            style "background-color"
                  (if isActive then "DodgerBlue" else "#fff"),
            style "color" (if isActive then "#ffffff" else "#000000"),
            style "border-bottom" "1px solid #d4d4d4"]
           [text name]

