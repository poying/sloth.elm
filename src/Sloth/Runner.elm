module Sloth.Runner (run) where


{-|
@docs run
-}


import Result
import Sloth exposing (..)
import Sloth.Reporter.Json as Json
import Sloth.Reporter.Ansi as Ansi


{-| -}
run : String -> Sloth -> String
run mode sloth =
  case render mode sloth of
    Nothing ->
      ""
    Just output ->
      output


render : String -> Sloth -> Maybe String
render mode sloth =
  case mode of
    "json" ->
      Json.render sloth
    "ansi" ->
      Ansi.render sloth
    _ ->
      Nothing
