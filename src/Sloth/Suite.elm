module Sloth.Suite where


{-|
@docs Content, TestStatus, appendChild
-}


import List exposing (append)


{-| -}
type TestStatus
  = Pass
  | Fail


{-| -}
type Content
  = Root (List Content)
  | TestSuite String (List Content)
  | TestCase String TestStatus


{-| -}
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
    TestCase _ _ ->
      Err "You can't append content to TestCase."
