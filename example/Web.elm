module Main where


import Sloth exposing (..)
import Sloth.Reporters exposing (json)
import Graphics.Element exposing (show)


tests =
  tree
    `describe` "a"
      `it` "1" => err "a1.err"
      `it` "2" => err "a2.err"
      `end` 1
    `describe` "b"
      `it` "1" => err "b1.err"
      `it` "2" => ok
      `describe` "c"
        `it` "1" => err "c1.err"
        `it` "2" => err "c2.err"
        `end` 2


main = show (json [("Web.elm", tests)])
