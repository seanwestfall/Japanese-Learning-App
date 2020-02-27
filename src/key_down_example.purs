-- |Handles key presses for keys that can be held down.
keydown :: forall s e. STRef s State -> DOMEvent -> Eff (st :: ST s, dom :: DOM | e) Unit
keydown st event = do
  code <- keyCode event
  modifySTRef st $ \state ->
      let controls = case code of
                       65  -> state.controls { left = true }
                       83  -> state.controls { right = true }
                       75  -> state.controls { thrust = 0.5 }
                       _   -> state.controls
      in state { controls = controls }

  return unit

-- |Handles key releases for keys that can be held down.
keyup :: forall s e. STRef s State -> DOMEvent -> Eff (st :: ST s, dom :: DOM | e) Unit
keyup st event = do
  code <- keyCode event
  modifySTRef st $ \state ->
      let controls = case code of
                       65  -> state.controls { left = false }
                       83  -> state.controls { right = false }
                       75  -> state.controls { thrust = 0.0 }
                       _   -> state.controls
      in state { controls = controls }

  return unit

-- |Handles single key presses.
keypress :: forall s e. STRef s State -> DOMEvent -> Eff (st :: ST s, wau :: WebAudio, dom :: DOM, random :: Random | e) Unit
keypress st event = do
  state <- readSTRef st
  k <- key event
  case state.phase of
    Playing ship | (k == "l" || k == "L") -> do
      let x = ship.x
          y = ship.y
          dx = ship.dx + 8 * cos (ship.dir - pi/2)
          dy = ship.dy + 8 * sin (ship.dir - pi/2)
          missile = { x: x, y: y, dx: dx, dy: dy, r: 1, fuse: 50 }

      writeSTRef st $ state { missiles = (missile : state.missiles) }
      playBufferedSound state.sounds state.sounds.shootBuffer
      return unit

    GameOver | (k == " ") -> do
      asteroids <- replicateM 10 (randomAsteroid state.w state.h)
      writeSTRef st $ state { phase     = Respawning 11
                            , nships    = 3
                            , score     = 0
                            , asteroids = asteroids
                            }
      return unit

    _ -> return unit
