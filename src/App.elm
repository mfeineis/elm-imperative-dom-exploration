port module App exposing (main)

import Json.Decode as Decode exposing (Value)
import Json.Encode as Encode
import View as Html exposing (Html)


port render : Value -> Cmd msg


type alias Model =
    { isNew : Bool
    , series : List String
    }


type Msg
    = ButtonClicked


init : () -> ( Model, Cmd Msg )
init _ =
    ( { isNew = True
      , series = [ "Avatar", "Firefly", "She-Ra" ]
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view { isNew, series } =
    Html.div []
        [ Html.branchIf
            (Html.text "Hello, World!")
            (Html.text "Godspeed You, Black Emperor")
            isNew
        , Html.forEach
            (\it -> Html.div [] [ Html.text it ])
            series
        , Html.div []
            [ Html.button
                [ Html.onClick ButtonClicked
                ]
                [ Html.text "Click Me!" ]
            , Html.button
                [ Html.disabled True
                ]
                [ Html.text "You can't click Me!" ]
            ]
        ]


main : Program () Model Msg
main =
    let
        wrap ( model, cmd ) =
            ( model
            , Cmd.batch
                [ cmd
                , render (Html.toJson (view model))
                ]
            )
    in
    Platform.worker
        { init =
            \flags ->
                wrap (init flags)
        , subscriptions = subscriptions
        , update =
            \msg model ->
                wrap (update msg model)
        }
