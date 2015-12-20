module Main where


import Sloth exposing (..)
import Result exposing (Result(Ok, Err))
import Graphics.Element exposing (show)
import Debug


tests =
  sloth
    `describe` "a"
      `it` ("1", (Err "a1.err"))
      `it` ("2", (Err "a2.err"))
    `break` 1
    `describe` "b"
      `it` ("1", (Err "b1.err"))
      `it` ("2", (Ok "b2.ok"))
      `describe` "c"
        `it` ("1", (Err "c1.err"))
        `it` ("2", (Err "c2.err"))
      `break` 2


main =
  show tests
