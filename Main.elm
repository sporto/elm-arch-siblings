module Main (..) where

import Html exposing (..)
import StartApp
import Effects exposing (Effects, Never)
import Debug
import Task
import MainActions exposing (..)
import Messages
import MessagesActions
import Trigger


type alias Model =
  { messagesModel : Messages.Model
  }


initialModel : Model
initialModel =
  { messagesModel = Messages.initialModel
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
    , Trigger.view (Signal.forwardTo address TriggerAction) ""
    ]



-- UPDATE


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case (Debug.log "action" action) of
    MessagesAction subAction ->
      let
        ( updated, fx ) =
          Messages.update subAction model.messagesModel
      in
        ( { model | messagesModel = updated }, Effects.map MessagesAction fx )

    TriggerAction subAction ->
      let
        ( updated, subFx, mainFx ) =
          Trigger.update subAction ""

        fx =
          Effects.batch [ (Effects.map TriggerAction subFx), mainFx ]
      in
        ( model, fx )

    ShowMessage message ->
      let
        fx =
          Task.succeed (MessagesActions.ShowMessage message)
            |> Effects.task
            |> Effects.map MessagesAction
      in
        ( model, fx )


app : StartApp.App Model
app =
  StartApp.start
    { init = init
    , inputs = []
    , update = update
    , view = view
    }


main : Signal.Signal Html
main =
  app.html


port runner : Signal (Task.Task Never ())
port runner =
  app.tasks
