module Trigger (..) where

import Html exposing (..)
import Html.Events exposing (onClick)
import Effects exposing (Effects, Never)
import TriggerActions exposing (..)
import MessagesActions


type alias Model =
  { messageAddress : Signal.Address MessagesActions.Action
  }


initialModel : Signal.Address MessagesActions.Action -> Model
initialModel messageAddress =
  { messageAddress = messageAddress
  }



-- VIEW


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    [ button
        [ onClick model.messageAddress (MessagesActions.ShowMessage "Hello") ]
        [ text "Send message" ]
    ]



-- UPDATE


update : Action -> Model -> ( Model, Effects Action )
update action model =
  (model, Effects.none)
