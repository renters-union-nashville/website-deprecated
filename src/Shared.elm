module Shared exposing (Data, Model, Msg, template)

import Browser.Events exposing (onResize)
import Browser.Navigation as Nav
import DataSource
import DataSource.Port
import Element exposing (fill, width)
import Element.Font
import Html exposing (Html)
import Json.Encode as Encode
import OptimizedDecoder as Decode exposing (Decoder, int, string)
import OptimizedDecoder.Pipeline exposing (required)
import Pages.Flags exposing (Flags(..))
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import Runtime exposing (Runtime)
import SharedTemplate exposing (SharedTemplate)
import View exposing (View)
import View.Header
import Window exposing (Window)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | ToggleMobileMenu
    | SetWindow Int Int


type alias Data =
    { runtime : Runtime
    }


type alias Model =
    { showMobileMenu : Bool
    , navigationKey : Maybe Nav.Key
    , queryParams : Maybe String
    , window : Window
    , hostName : Maybe String
    }


windowDecoder : Decoder Window
windowDecoder =
    Decode.succeed Window
        |> required "width" int
        |> required "height" int


init :
    Maybe Nav.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init navigationKey flags maybePagePath =
    let
        window =
            case flags of
                BrowserFlags value ->
                    Decode.decodeValue (Decode.field "window" windowDecoder) value
                        |> Result.withDefault { width = 0, height = 0 }

                PreRenderFlags ->
                    { width = 0, height = 0 }

        maybeHostName =
            case flags of
                BrowserFlags value ->
                    Decode.decodeValue (Decode.field "hostName" Decode.string) value
                        |> Result.toMaybe

                PreRenderFlags ->
                    Nothing
    in
    ( { showMobileMenu = False
      , navigationKey = navigationKey
      , queryParams =
            Maybe.andThen (.query << .path) maybePagePath
      , window = window
      , hostName =
            maybeHostName
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange pageUrl ->
            ( { model
                | showMobileMenu = False
                , queryParams = pageUrl.query
              }
            , Cmd.none
            )

        ToggleMobileMenu ->
            ( { model | showMobileMenu = not model.showMobileMenu }, Cmd.none )

        SetWindow width height ->
            ( { model | window = { width = width, height = height } }, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ model =
    Sub.batch
        [ onResize SetWindow
        ]


data : DataSource.DataSource Data
data =
    DataSource.map Data
        (DataSource.map3 Runtime
            (DataSource.Port.get "environmentVariable"
                (Encode.string "COMMIT_REF")
                Runtime.decodeCodeVersion
            )
            (DataSource.Port.get "today" (Encode.string "meh") Runtime.decodeDate)
            (DataSource.Port.get "today" (Encode.string "meh") Runtime.decodeIso8601)
        )


view :
    Data
    ->
        { path : Path
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html msg, title : String }
view tableOfContents page model toMsg pageView =
    { body =
        (View.Header.view
            { showMobileMenu = model.showMobileMenu
            , toggleMobileMenu = ToggleMobileMenu
            }
            page
            |> Element.map toMsg
        )
            :: pageView.body
            |> Element.column
                [ width fill
                , Element.Font.family [ Element.Font.typeface "system" ]
                ]
            |> Element.layout [ width fill ]
    , title = pageView.title
    }
