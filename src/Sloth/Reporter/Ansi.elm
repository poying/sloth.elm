module Sloth.Reporter.Ansi (render) where


import List exposing (foldr, map)
import String exposing (repeat)
import Sloth exposing (..) 
import Sloth.Suite as Suite
import Result exposing (Result(..))


render : Sloth -> Maybe String
render sloth =
  case sloth of
    Root ->
      Nothing
    InvalidSloth message ->
      Just ("\"" ++ message ++ "\"")
    Sloth _ content ->
      Just (contentToString 0 content)


contentToString : Int -> Suite.Content -> String
contentToString level content =
  case content of
    Suite.Root children ->
      let
        outputs = map (contentToString level) children
      in
        foldr (++) "" outputs
    Suite.TestSuite title children ->
      let
        outputs = map (contentToString (level + 1)) children
        combinedOutput = foldr (++) "" outputs
        prefix = repeat level "  "
      in
        prefix ++ title ++ "\n" ++ combinedOutput
    Suite.TestCase title result ->
      let
        prefix  = repeat level "  "
      in
         case result of
           Ok _ ->
             prefix ++ title
           Err message ->
             prefix ++ title ++ "(" ++ message ++ ")"
