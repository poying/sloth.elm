module Sloth.Reporters.Ansi (render) where


import String exposing (join)
import List exposing (map, filter, foldl)
import String exposing (repeat)
import Sloth.Suite as Suite
import Sloth.Data exposing (..) 
import Sloth.Counter exposing (Counter)


render : Counter -> List (String, Data) -> String
render counter list =
  let
    count = renderCounter counter
    detail = renderDetail list
  in
    detail ++ "\n\n" ++ count


renderCounter : Counter -> String
renderCounter counter =
  let
    passing = toString counter.passing
    failing = toString counter.failing
  in
    ""
      |> (++) (red ("  " ++ failing ++ " failing"))
      |> (++) (green ("  " ++ passing ++ " passing\n"))


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
    Suite.TestCase title status ->
      let
        prefix  = repeat level "  "
      in
         case status of
           Suite.Pass ->
             prefix
               ++ green "✔︎ "
               ++ title
           Suite.Fail ->
             prefix
               ++ red "✘ "
               ++ title


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
