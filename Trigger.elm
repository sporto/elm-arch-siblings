module Trigger (..) where

import Html exposing (..)
import Html.Events exposing (onClick)
import Effects exposing (Effects, Never)
import Task
import MainActions
import TriggerActions exposing (..)


type alias Model =
  String



-- VIEW


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    [ button [ onClick address (ShowMessage "Hello") ] [ text "Send message" ]
    ]



-- UPDATE


update : Action -> Model -> ( Model, Effects Action, Effects MainActions.Action )
update action model =
  case action of
    ShowMessage msg ->
      let
        mainFx =
          Task.succeed (MainActions.ShowMessage msg)
            |> Effects.task
      in
        ( model, Effects.none, mainFx )
