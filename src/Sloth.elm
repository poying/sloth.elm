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


it : Sloth -> (String, Result String String) -> Sloth
it sloth (title, testResult) =
  case sloth of
    Sloth _ _ ->
      appendContent sloth (Suite.TestCase title testResult)
    Root ->
      InvalidSloth "WTF!"
    InvalidSloth _ ->
      sloth


break : Sloth -> Int -> Sloth
break sloth level =
  case sloth of
    Sloth parent content ->
      if level == 0 then
        sloth
      else
        break (appendContent parent content) (level - 1)
    Root ->
      InvalidSloth "WTF!"
    InvalidSloth _ ->
      sloth


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
