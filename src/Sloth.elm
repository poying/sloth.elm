module Sloth where


import Sloth.Suite as Suite
import Maybe exposing (Maybe(Just, Nothing))


type Sloth
  = Sloth Sloth Suite.Content
  | Root
  | InvalidSloth String


sloth : Sloth
sloth =
  Sloth Root (Suite.Root [])


describe : Sloth -> String -> Sloth
describe sloth title =
  case sloth of
    Sloth _ _ ->
      Sloth sloth (Suite.TestSuite title [])
    Root ->
      InvalidSloth "WTF!"
    InvalidSloth _ ->
      sloth


infixl 8 `describe`


it : Sloth -> (String, Suite.TestResult) -> Sloth
it sloth (title, testResult) =
  case sloth of
    Sloth _ _ ->
      appendContent sloth (Suite.TestCase title testResult)
    Root ->
      InvalidSloth "WTF!"
    InvalidSloth _ ->
      sloth


infixl 8 `it`


end : Sloth -> Int -> Sloth
end sloth level =
  case sloth of
    Sloth parent content ->
      if level == 0 then
        sloth
      else
        end (appendContent parent content) (level - 1)
    Root ->
      InvalidSloth "WTF!"
    InvalidSloth _ ->
      sloth


infixl 8 `end`


appendContent : Sloth -> Suite.Content -> Sloth
appendContent sloth content = 
  case sloth of
    Sloth parentSloth parentContent ->
      let
        result = Suite.appendChild parentContent content
      in
        case result of
          Ok newContent ->
            Sloth parentSloth newContent
          Err message ->
            InvalidSloth message
    Root ->
      InvalidSloth "WTF!"
    InvalidSloth _ ->
      sloth


getContent : Sloth -> Maybe Suite.Content
getContent sloth =
  case sloth of
    Sloth _ content ->
      Just content
    Root ->
      Nothing
    InvalidSloth _ ->
      Nothing


(=>) : String -> Suite.TestResult -> (String, Suite.TestResult)
(=>) title result =
  (title, result)


infixl 9 =>


ok : Suite.TestResult
ok = 
  Ok Nothing


err : String -> Suite.TestResult
err message =
  Err message
