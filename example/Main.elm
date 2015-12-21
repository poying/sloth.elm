module Main where


import Sloth exposing (..)
import Sloth.Reporter.Json exposing (render)
import Result exposing (Result(Ok, Err))
import Graphics.Element exposing (show)
import Debug


tests =
  sloth
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


main =
  case render tests of
    Just json ->
      show json
        |> Debug.log "json"
    Nothing ->
      show "Nothing"
