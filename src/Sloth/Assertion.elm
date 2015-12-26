module Sloth.Assertion
  ( shouldBe
  , shouldNotBe
  ) where


import Sloth.Suite as Suite
import Sloth.Data exposing (..)


assert : Bool -> Suite.TestStatus
assert bool =
  case bool of
    True ->
      Suite.Pass
    False ->
      Suite.Fail


shouldBe : a -> a -> Suite.TestStatus
shouldBe actual expect =
  assert (actual == expect)


shouldNotBe : a -> a -> Suite.TestStatus
shouldNotBe actual expect =
  assert (actual /= expect)
