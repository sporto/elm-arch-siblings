module Trigger (..) where

import Html exposing (..)
import Html.Events exposing (onClick)
import Effects exposing (Effects, Never)
import Task
import TriggerActions exposing (..)


type alias Model =
  { messageAddress : Signal.Address String
  }


initialModel : Signal.Address String -> Model
initialModel messageAddress =
  { messageAddress = messageAddress
  }



-- VIEW


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    [ button
        [ onClick address (ShowMessage "Hello") ]
        [ text "Send message" ]
    ]



-- UPDATE


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    ShowMessage msg ->
      ( model
      , sendAsEffect model.messageAddress msg Tasks
      )

    Tasks _ ->
      ( model, Effects.none )



-- here for now instead of Ext.Signal.sendAsEffect as in elm-ui from @gdotdesign


sendAsEffect : Signal.Address a -> a -> (() -> b) -> Effects.Effects b
sendAsEffect address value action =
  Signal.send address value
    |> Effects.task
    |> Effects.map action
