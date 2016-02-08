module Main (..) where

import Html exposing (..)
import StartApp
import Effects exposing (Effects, Never)
import Debug
import Task
import MainActions exposing (..)
import Messages
import MessagesActions
import Signal exposing (forwardTo)
import Trigger


mailbox : Signal.Mailbox Action
mailbox =
  Signal.mailbox NoOp


type alias Model =
  { messagesModel : Messages.Model
  , triggerModel : Trigger.Model
  }


initialModel : Model
initialModel =
    { messagesModel = Messages.initialModel
    , triggerModel =
        Trigger.init
          (forwardTo mailbox.address TriggerValue)
          "Hello"
    }


init : ( Model, Effects Action )
init =
  ( initialModel, Effects.none )



-- VIEW


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    [ Messages.view (Signal.forwardTo address MessagesAction) model.messagesModel
    , Trigger.view (Signal.forwardTo address TriggerAction) model.triggerModel
    ]


-- UPDATE


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case (Debug.log "action" action) of
    NoOp ->
      (model, Effects.none)

    MessagesAction subAction ->
      let
        ( updated, fx ) =
          Messages.update subAction model.messagesModel
      in
        ( { model | messagesModel = updated }, Effects.map MessagesAction fx )

    TriggerAction subAction ->
      let
        ( updated, fx ) =
          Trigger.update subAction model.triggerModel
      in
        ( { model | triggerModel = updated }, Effects.map TriggerAction fx )

    TriggerValue message ->
      let
        ( updated, fx ) =
          Messages.update (MessagesActions.ShowMessage message) model.messagesModel
      in
        ( { model | messagesModel = updated }, Effects.map MessagesAction fx )


app : StartApp.App Model
app =
  StartApp.start
    { init = init
    , inputs =
      [ mailbox.signal
      ]
    , update = update
    , view = view
    }


main : Signal.Signal Html
main =
  app.html


port runner : Signal (Task.Task Never ())
port runner =
  app.tasks
