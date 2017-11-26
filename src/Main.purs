module Main (main) where

import Prelude
import Components.Map
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import DOM (DOM) as DOM
import Thermite as T

-- | The main method that renders to the document body.
main :: Eff (dom :: DOM.DOM) Unit
main = T.defaultMain .. unit
