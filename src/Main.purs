module Main (main) where

import Prelude
import Components.Map
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import DOM (DOM) as DOM
import Thermite as T

data Event
  = UserClick String
  | ResetColor
  | StartGame
  | NextSequence (List String)
  | AnimateColor String

-- | The main method that renders to the document body.
main :: Eff (dom :: DOM.DOM) Unit
main = T.defaultMain .. unit


-- How to handle a key press!
table :: forall props eff. T.Spec eff TaskListState props TaskListAction -> T.Spec eff TaskListState props TaskListAction
  table = over T._render \render dispatch p s c ->
    let handleKeyPress :: Int -> String -> _
        handleKeyPress 13 text = dispatch $ NewTask text
        handleKeyPress 27 _    = dispatch $ SetEditText ""
        handleKeyPress _  _    = pure unit
    in [ R.table [ RP.className "table table-striped" ]
                 [ R.thead' [ R.th [ RP.className "col-md-1"  ] []
                            , R.th [ RP.className "col-md-10" ] [ R.text "Description" ]
                            , R.th [ RP.className "col-md-1"  ] []
                            ]
                 , R.tbody' $ [ R.tr' [ R.td' []
                                      , R.td' [ R.input [ RP.className "form-control"
                                                        , RP.placeholder "Create a new task"
                                                        , RP.value s.editText
                                                        , RP.onKeyUp \e -> handleKeyPress (unsafeCoerce e).keyCode (unsafeCoerce e).target.value
                                                        , RP.onChange \e -> dispatch (SetEditText (unsafeCoerce e).target.value)
                                                        ] []
                                              ]
                                      , R.td' []
                                      ]
                              ] <> render dispatch p s c
                 ]
       ]
