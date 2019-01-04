# elm-autocomplete

I transliterated a w3schools How TO on Autocomplete input text fields to to my
disatisfaction with existing Elm autocomplete libraries. This is a work in
progress and I will complete it when I'm done testing it by using it in another
project of mine.

## Installation

When I finish work on this and get it uploaded to packages.elm.org, it will
be something like this to install.

```
elm install mmachenry/elm-autocomplete
```

## Setup
```elm
import Autocomplete

main : Program () Model Msg
main = Browser.element {
    init = \_ -> ( Autocomplete.init, Cmd.none ),
    update = update,
    view = view,
    subscriptions = (\model->Autocomplete.subscriptions model config)
    }

type Msg =
    UpdateAuto Autocomplete.State

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    UpdateAuto newState -> (newState, Cmd.none)

config = {
    updateMessage = UpdateAuto,
    match = getMatches,
    inputAttributes = []
    }

countries = ["Afghanistan","Albania","Algeria","Andorra", ...]

getMatches : String -> List String
getMatches query =
    List.filter (String.startsWith query) countries
    |> List.take 10

view : Model -> Html Msg
view model = Autocomplete.inputHtml myConfig model.autoState
```

## References
[w3schools How TO - Autocomplete](https://www.w3schools.com/howto/howto_js_autocomplete.asp)

