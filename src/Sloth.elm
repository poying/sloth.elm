module Sloth
  ( tree
  , describe, it, end
  , ok, err
  , (=>)
  ) where


{-|
@docs tree
@docs describe, it, end
@docs ok, err
@docs (=>)
-}


import Sloth.Suite as Suite
import Sloth.Data exposing (..)
import Sloth.Reporters


{-| -}
tree : Data
tree =
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
it : Data -> (String, Suite.TestResult) -> Data
it data (title, testResult) =
  case data of
    Node _ _ ->
      appendContent data (Suite.TestCase title testResult)
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
(=>) : String -> Suite.TestResult -> (String, Suite.TestResult)
(=>) title result =
  (title, result)


infixl 9 =>


{-| -}
ok : Suite.TestResult
ok = 
  Ok Nothing


{-| -}
err : String -> Suite.TestResult
err message =
  Err message
