module Sloth
  ( start
  , describe, it, end
  , (=>)
  ) where


{-|
@docs start
@docs describe, it, end
@docs ok, err
@docs (=>)
-}


import Sloth.Suite as Suite
import Sloth.Data exposing (..)
import Sloth.Reporters


{-| -}
start : Data
start =
  Node Root (Suite.Root [])


{-| -}
describe : Data -> String -> Data
describe data title =
  case data of
    Node _ _ ->
      Node data (Suite.TestSuite title [])
    Root ->
      InvalidNode "You can't create test suites in Root."
    InvalidNode _ ->
      data


infixl 8 `describe`


{-| -}
it : Data -> (String, Suite.TestStatus) -> Data
it data (title, status) =
  case data of
    Node _ _ ->
      appendContent data (Suite.TestCase title status)
    Root ->
      InvalidNode "You can't create test cases in Root."
    InvalidNode _ ->
      data


infixl 8 `it`


{-| -}
end : Data -> Int -> Data
end data level =
  case data of
    Node parent content ->
      if level == 0 then
        data
      else
        end (appendContent parent content) (level - 1)
    Root ->
      data
    InvalidNode _ ->
      data


infixl 8 `end`


{-| -}
(=>) : String -> Suite.TestStatus -> (String, Suite.TestStatus)
(=>) title result =
  (title, result)


infixl 9 =>
