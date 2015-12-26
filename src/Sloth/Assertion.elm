module Sloth.Assertion where


import Sloth.Suite as Suite
import Sloth.Data exposing (..)


assert : Bool -> String -> Suite.TestResult
assert bool message =
  case bool of
    True ->
      Ok Nothing
    False ->
      Err message
