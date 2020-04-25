module Main exposing (..)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation
import Html exposing (Html, text)
import Page.CreateGame as CreateGame
import Route
import Url exposing (Url)



---- MODEL ----


type Page
    = CreateGame CreateGame.Model
    | NotFound


type alias Model =
    { navKey : Navigation.Key
    , page : Page
    }


init : () -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url navKey =
    setNewPage (Route.match url) (initialModel navKey)


initialModel : Navigation.Key -> Model
initialModel navKey =
    { navKey = navKey
    , page = NotFound
    }



---- UPDATE ----


type Msg
    = ClickLink UrlRequest
    | CreateGameMsg CreateGame.Msg
    | NewRoute (Maybe Route.Route)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( ClickLink urlRequest, _ ) ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Navigation.pushUrl model.navKey (Url.toString url)
                    )

                External url ->
                    ( model
                    , Navigation.load url
                    )

        ( CreateGameMsg createGameMsg, CreateGame createGameModel ) ->
            let
                ( updatedCreateGameModel, createGameCmd ) =
                    CreateGame.update createGameMsg createGameModel
            in
            ( { model | page = CreateGame updatedCreateGameModel }
            , Cmd.map CreateGameMsg createGameCmd
            )

        ( NewRoute maybeRoute, _ ) ->
            setNewPage maybeRoute model

        _ ->
            ( model, Cmd.none )


setNewPage : Maybe Route.Route -> Model -> ( Model, Cmd Msg )
setNewPage maybeRoute model =
    case maybeRoute of
        Just Route.CreateGame ->
            let
                ( createGameModel, createGameCmd ) =
                    CreateGame.init
            in
            ( { model | page = CreateGame createGameModel }, Cmd.map CreateGameMsg createGameCmd )

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        _ ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Document Msg
view model =
    let
        ( title, content ) =
            viewContent model.page
    in
    { title = title
    , body = [ content ]
    }


viewContent : Page -> ( String, Html Msg )
viewContent page =
    case page of
        CreateGame createGameModel ->
            ( "Create Game"
            , CreateGame.view createGameModel |> Html.map CreateGameMsg
            )

        NotFound ->
            ( "Page Not Found"
            , text "Could not find this page"
            )



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        , onUrlRequest = ClickLink
        , onUrlChange = Route.match >> NewRoute
        }
