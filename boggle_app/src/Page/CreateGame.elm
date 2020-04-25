module Page.CreateGame exposing (Model, Msg, init, update, view)

import Html exposing (Html, div, input, text)
import Html.Attributes exposing (class, classList, type_, value)
import Html.Events exposing (onClick, onInput)



---- MODEL ----


type alias Model =
    { username : String }


init : ( Model, Cmd Msg )
init =
    ( { username = "" }, Cmd.none )



---- UPDATE ----


type Msg
    = CreateGame
    | UpdateUsername String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CreateGame ->
            ( model, Cmd.none )

        UpdateUsername updatedUsername ->
            ( { model | username = updatedUsername }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    let
        validUsername =
            String.length model.username >= 3
    in
    div
        [ class "flex flex-col h-full items-center justify-center" ]
        [ div
            []
            [ div
                [ class "pb-2 text-cool-gray-700" ]
                [ text "Username" ]
            , input
                [ class "rounded-md p-4 w-64 bg-cool-gray-800 text-cool-gray-300"
                , onInput UpdateUsername
                , type_ "text"
                , value model.username
                ]
                []
            , div
                [ class "rounded-md p-4 w-64 bg-cool-gray-800 text-cool-gray-400 text-center mt-2 animated cursor-pointer hover:bg-cool-gray-700 hover:text-cool-gray-300"
                , onClick CreateGame
                , classList
                    [ ( "invisible", not validUsername )
                    , ( "fade-in", validUsername )
                    ]
                ]
                [ text "Create Game" ]
            , div
                [ class "rounded-md border border-cool-gray-800 text-cool-gray-400 cursor-pointer hover:bg-cool-gray-800 hover:text-cool-gray-300 p-2 mt-16  text-center" ]
                [ text "Join existing game" ]
            ]
        ]
