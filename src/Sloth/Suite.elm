module Sloth.Suite where


import List exposing (append)
import Result exposing (Result(..))


type Content
  = Root (List Content)
  | TestSuite String (List Content)
  | TestCase String (Result String String)


appendChild : Content -> Content -> Result String Content
appendChild parent child =
  case parent of
    Root children ->
      let
        value = children ++ [child]
          |> Root
      in
        Ok value
    TestSuite title children ->
      let
        value = children ++ [child]
          |> TestSuite title
      in
        Ok value
    TestCase title _ ->
      Err "WTF!"
