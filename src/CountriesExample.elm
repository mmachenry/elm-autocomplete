-- https://www.w3schools.com/howto/howto_js_autocomplete.asp

module CountriesExample exposing (main)

import Browser
import Autocomplete
import Html exposing (Html, div, button, text, p)
import Html.Attributes exposing (style, placeholder)
import Html.Events exposing (onClick)

main : Program () Model Msg
main = Browser.element {
    init = \_ -> ( init, Cmd.none ),
    update = update,
    view = view,
    subscriptions = (\m->Autocomplete.subscriptions m.autoState myConfig)
    }

type alias Model = {
    selected : Maybe String,
    autoState : Autocomplete.State
    }

type Msg =
    UpdateAuto Autocomplete.State
  | Submit

init = {
    selected = Nothing,
    autoState = Autocomplete.init
    }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    Submit ->
        ({ model | selected =
            Just (Autocomplete.getValue model.autoState) }, Cmd.none)
    UpdateAuto newState -> ({ model | autoState = newState }, Cmd.none)

myConfig = {
    updateMessage = UpdateAuto,
    match = getMatches,
    inputAttributes = [
        placeholder "Country",
        style "border" "1px solid transparent",
        style "background-color" "#f1f1f1",
        style "padding" "10px",
        style "font-size" "16px",
        style "background-color" "#f1f1f1"
        ]
    }

countries = ["Afghanistan","Albania","Algeria","Andorra","Angola","Anguilla","Antigua & Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnia & Herzegovina","Botswana","Brazil","British Virgin Islands","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","Cape Verde","Cayman Islands","Central Arfrican Republic","Chad","Chile","China","Colombia","Congo","Cook Islands","Costa Rica","Cote D Ivoire","Croatia","Cuba","Curacao","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia","Ethiopia","Falkland Islands","Faroe Islands","Fiji","Finland","France","French Polynesia","French West Indies","Gabon","Gambia","Georgia","Germany","Ghana","Gibraltar","Greece","Greenland","Grenada","Guam","Guatemala","Guernsey","Guinea","Guinea Bissau","Guyana","Haiti","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Isle of Man","Israel","Italy","Jamaica","Japan","Jersey","Jordan","Kazakhstan","Kenya","Kiribati","Kosovo","Kuwait","Kyrgyzstan","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macau","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Mauritania","Mauritius","Mexico","Micronesia","Moldova","Monaco","Mongolia","Montenegro","Montserrat","Morocco","Mozambique","Myanmar","Namibia","Nauro","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","North Korea","Norway","Oman","Pakistan","Palau","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Puerto Rico","Qatar","Reunion","Romania","Russia","Rwanda","Saint Pierre & Miquelon","Samoa","San Marino","Sao Tome and Principe","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","South Korea","South Sudan","Spain","Sri Lanka","St Kitts & Nevis","St Lucia","St Vincent","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Timor L'Este","Togo","Tonga","Trinidad & Tobago","Tunisia","Turkey","Turkmenistan","Turks & Caicos","Tuvalu","Uganda","Ukraine","United Arab Emirates","United Kingdom","United States of America","Uruguay","Uzbekistan","Vanuatu","Vatican City","Venezuela","Vietnam","Virgin Islands (US)","Yemen","Zambia","Zimbabwe"]

getMatches : String -> List String
getMatches query =
    List.filter (String.startsWith query) countries
    |> List.take 10

view : Model -> Html Msg
view model = div [] [
    Autocomplete.inputHtml myConfig model.autoState,
    button [onClick Submit,
            style "background-color" "DodgerBlue",
            style "margin-left" "2px",
            style "color" "#fff",
            style "border" "1px solid transparent",
            style "padding" "10px",
            style "font-size" "16px",
            style "cursor" "pointer"
            ] [text "Submit"],
    div [] [
        p [] [text (Autocomplete.getValue model.autoState)],
        p [] [text (Maybe.withDefault "" model.selected)]
        ]
    ]

