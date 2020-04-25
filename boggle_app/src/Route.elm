module Route exposing (Route(..), href, match, pushUrl, replaceUrl)

import Browser.Navigation as Navigation
import Html
import Html.Attributes
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, s, string, top)


type Route
    = CreateGame
    | JoinGame String
    | Game String


routes : Parser (Route -> a) a
routes =
    Parser.oneOf
        [ Parser.map CreateGame top
        , Parser.map CreateGame (s "create")
        , Parser.map JoinGame (s "games" </> string </> s "join")
        , Parser.map Game (s "games" </> string)
        ]


match : Url -> Maybe Route
match url =
    Parser.parse routes url


pushUrl : Navigation.Key -> Route -> Cmd msg
pushUrl navKey route =
    Navigation.pushUrl navKey (routeToUrl route)


replaceUrl : Navigation.Key -> Route -> Cmd msg
replaceUrl key route =
    Navigation.replaceUrl key (routeToUrl route)


routeToUrl : Route -> String
routeToUrl route =
    let
        urlParts =
            case route of
                CreateGame ->
                    [ "create" ]

                JoinGame gameId ->
                    [ "games", gameId, "join" ]

                Game gameId ->
                    [ "games", gameId ]
    in
    "/" ++ String.join "/" urlParts


href : Route -> Html.Attribute msg
href route =
    Html.Attributes.href (routeToUrl route)
