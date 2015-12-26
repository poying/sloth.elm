module Sloth
  ( start
  , describe, it, end
  , (=>)
  ) where


{-| Sloth is a testing framework from Elm. It is inspired from the Node.js module [Mocha](https://github.com/mochajs/mocha).

# Creating Tests
@docs start, describe, it, end

# Operators
@docs (=>)
-}


import Sloth.Suite as Suite
import Sloth.Data exposing (..)
import Sloth.Reporters


{-| Create a `Data` which conatins all test cases and suites. -}
start : Data
start =
  Node Root (Suite.Root [])


{-| Open a describe block. -}
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


{-| Create a test case. -}
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


{-| Close describe block(s). -}
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
