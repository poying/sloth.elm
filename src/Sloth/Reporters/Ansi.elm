module Sloth.Reporters.Ansi (render) where


import String exposing (join)
import List exposing (map, filter, foldl)
import String exposing (repeat)
import Sloth.Suite as Suite
import Sloth.Counter as Counter
import Sloth.Data exposing (..) 
import Result exposing (Result(..))


render : List (String, Data) -> String
render list =
  let
    count = renderCounter list
    detail = renderDetail list
  in
    detail ++ "\n\n" ++ count


renderCounter : List (String, Data) -> String
renderCounter list =
  let
    counter = list
      |> map countData
      |> foldl Counter.combine Counter.counter
    passing = toString counter.passing
    failing = toString counter.failing
  in
    ""
      ++ green ("  " ++ passing ++ " passing\n")
      ++ red ("  " ++ failing ++ " failing")


countData : (String, Data) -> Counter.Counter
countData (_, data) =
  case data of
    Root ->
      Counter.counter
    InvalidNode _ ->
      Counter.counter
    Node _ content ->
      countContent content


countContent : Suite.Content -> Counter.Counter
countContent content =
  case content of
    Suite.Root children ->
      children
        |> map countContent
        |> foldl Counter.combine Counter.counter
    Suite.TestSuite _ children ->
      children
        |> map countContent
        |> foldl Counter.combine Counter.counter
    Suite.TestCase title result ->
      case result of
        Ok _ ->
          Counter.pass 
        Err message ->
          Counter.fail


renderDetail : List (String, Data) -> String
renderDetail list =
  list
    |> map renderData
    |> filter notNothing
    |> map maybeToString
    |> join "\n\n"


renderData : (String, Data) -> Maybe String
renderData (title, data) =
  case data of
    Root ->
      Nothing
    InvalidNode message ->
      Just ("  " ++ title ++ "\n\"" ++ message ++ "\"")
    Node _ content ->
      Just ("  " ++ title ++ "\n" ++ (contentToString 2 content))


contentToString : Int -> Suite.Content -> String
contentToString level content =
  case content of
    Suite.Root children ->
      children
        |> map (contentToString level)
        |> join "\n"
    Suite.TestSuite title children ->
      let
        prefix = repeat level "  "
      in
        children
          |> map (contentToString (level + 1))
          |> join "\n"
          |> (++) (prefix ++ title ++ "\n")
    Suite.TestCase title result ->
      let
        prefix  = repeat level "  "
      in
         case result of
           Ok _ ->
             prefix
               ++ green "✔︎ "
               ++ title
           Err message ->
             prefix
               ++ red "✘ "
               ++ title
               ++ gray (" (" ++ message ++ ")")


ansi : (Int, Int) -> String -> String
ansi (open, close) text =
  let
    open' = toString open
    close' = toString close
  in
    "\x1b[" ++ open' ++ "m"
      ++ text
      ++ "\x1b[" ++ close' ++ "m"


green : String -> String
green =
  ansi (32, 39)


red : String -> String
red =
  ansi (31, 39)


gray : String -> String
gray =
  ansi (90, 39)


notNothing : Maybe a -> Bool
notNothing value =
  case value of
    Just _ ->
      True
    Nothing ->
      False


maybeToString : Maybe String -> String
maybeToString maybe =
  case maybe of
    Just value ->
      value
    Nothing ->
      ""
