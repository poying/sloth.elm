module Sloth.Suite where


{-|
@docs Content, TestResult, appendChild, getChildren, getResult, getTestErrorMessage, getTitle, testFailed
-}


import List exposing (append)
import Result exposing (Result(..))


{-| -}
type alias TestResult =
  Result String (Maybe String)


{-| -}
type Content
  = Root (List Content)
  | TestSuite String (List Content)
  | TestCase String TestResult


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


{-| -}
getChildren : Content -> Maybe (List Content)
getChildren content =
  case content of
    Root children ->
      Just children
    TestSuite _ children ->
      Just children
    TestCase _ _ ->
      Nothing


{-| -}
getResult : Content -> Maybe TestResult
getResult content =
  case content of
    Root _ ->
      Nothing
    TestSuite _ _ ->
      Nothing
    TestCase _ result ->
      Just result


{-| -}
getTitle : Content -> Maybe String
getTitle content =
  case content of
    Root _ ->
      Nothing
    TestSuite title _ ->
      Just title
    TestCase title _ ->
      Just title


{-| -}
testFailed : TestResult -> Bool
testFailed result =
  case result of
    Ok _ ->
      False
    Err _ ->
      True


{-| -}
getTestErrorMessage : TestResult -> String
getTestErrorMessage result =
  case result of
    Ok _ ->
      ""
    Err message ->
      message
