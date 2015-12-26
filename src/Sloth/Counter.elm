module Sloth.Counter
  ( Counter
  , count
  ) where


import Sloth.Suite as Suite
import Sloth.Data exposing (..)
import List exposing (map, foldl)


type alias Counter =
  { passing : Int
  , failing : Int
  }


combine : Counter -> Counter -> Counter
combine first second =
  { passing = first.passing + second.passing
  , failing = first.failing + second.failing
  }


counter : Counter
counter =
  { passing = 0
  , failing = 0
  }


pass : Counter
pass =
  { counter |
      passing = counter.passing + 1
  }


fail : Counter
fail =
  { counter |
      failing = counter.failing + 1
  }


count : List (String, Data) -> Counter
count list =
  list
    |> map countData
    |> foldl combine counter


countData : (String, Data) -> Counter
countData (_, data) =
  case data of
    Root ->
      counter
    InvalidNode _ ->
      counter
    Node _ content ->
      countContent content


countContent : Suite.Content -> Counter
countContent content =
  case content of
    Suite.Root children ->
      children
        |> map countContent
        |> foldl combine counter
    Suite.TestSuite _ children ->
      children
        |> map countContent
        |> foldl combine counter
    Suite.TestCase title result ->
      case result of
        Suite.Pass ->
          pass 
        Suite.Fail ->
          fail
