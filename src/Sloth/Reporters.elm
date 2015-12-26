module Sloth.Reporters
  ( RenderResult (Pass, Fail)
  , json, ansi
  ) where


{-| Sloth.Reporters provides some method to render test results.

@docs RenderResult

@docs json, ansi
-}


import Sloth.Data exposing (..)
import Sloth.Counter exposing (Counter, count)
import Sloth.Reporters.Json as Json
import Sloth.Reporters.Ansi as Ansi


type alias Renderer =
  (Counter -> List (String, Data) -> String)


{-| -}
type RenderResult
  = Pass String
  | Fail String


render : Renderer -> List (String, Data) -> RenderResult
render renderer list =
  let
    counter = count list
    rendered = renderer counter list
  in
    case counter.failing of
      0 -> Pass rendered
      _ -> Fail rendered



{-| Render result as JSON. -}
json : List (String, Data) -> RenderResult
json =
  render Json.render


{-| Render result as ANSI. -}
ansi : List (String, Data) -> RenderResult
ansi =
  render Ansi.render
