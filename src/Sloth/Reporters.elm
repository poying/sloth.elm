module Sloth.Reporters
  ( json
  , ansi
  ) where


{-|
@docs json, ansi
-}


import Sloth.Data exposing (..)
import Sloth.Counter exposing (Counter, count)
import Sloth.Reporters.Json as Json
import Sloth.Reporters.Ansi as Ansi


type alias Renderer =
  (Counter -> List (String, Data) -> String)


type alias RenderResult =
  Result String String


render : Renderer -> List (String, Data) -> RenderResult
render renderer list =
  let
    counter = count list
    rendered = renderer counter list
  in
    case counter.failing of
      0 -> Ok rendered
      _ -> Err rendered



{-| -}
json : List (String, Data) -> RenderResult
json =
  render Json.render


{-| -}
ansi : List (String, Data) -> RenderResult
ansi =
  render Ansi.render
