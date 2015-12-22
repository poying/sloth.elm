module Sloth.Reporters
  ( json
  , ansi
  ) where


{-|
@docs json, ansi
-}


import Sloth.Data exposing (..)
import Sloth.Reporters.Json as Json
import Sloth.Reporters.Ansi as Ansi


{-| -}
json : List (String, Data) -> String
json =
  Json.render


{-| -}
ansi : List (String, Data) -> String
ansi =
  Ansi.render
