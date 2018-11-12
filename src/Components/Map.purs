module Components.Map where

import Prelude

import Control.Monad.Eff (Eff)
import Data.Foldable (fold)

import React.DOM as R
import React.DOM.Props as RP
import Thermite as T

main :: Eff (dom :: DOM) Unit
main =
    render $ fold
	[ h1 (text "Try PureScript!")
	      , p (text "Try out the examples below, or create your own!")
	]
  where