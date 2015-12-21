module Sloth.Reporter.Json (render) where


import List exposing (map)
import Json.Encode as Json
import Sloth.Suite as Suite
import Sloth exposing (..) 


render : Sloth -> Maybe String
render sloth =
  case sloth of
    Root ->
      Nothing
    InvalidSloth message ->
      Just (Json.encode 2 (errorMessageToJson message))
    Sloth _ content ->
      Just (Json.encode 2 (contentToJson content))


contentToJson : Suite.Content -> Json.Value
contentToJson content =
  case content of
    Suite.Root children ->
      Json.object
        [ ("type", Json.string "root")
        , ("children", Json.list (map contentToJson children))
        ]
    Suite.TestSuite title children ->
      Json.object
        [ ("type", Json.string "suite")
        , ("title", Json.string title)
        , ("children", Json.list (map contentToJson children))
        ]
    Suite.TestCase title result ->
      case result of
        Ok _ ->
          Json.object
            [ ("type", Json.string "case")
            , ("title", Json.string title)
            , ("failed", Json.bool False)
            ]
        Err message ->
          Json.object
            [ ("type", Json.string "case")
            , ("title", Json.string title)
            , ("failed", Json.bool True)
            , ("message", Json.string (Suite.getTestErrorMessage result))
            ]


errorMessageToJson : String -> Json.Value
errorMessageToJson message =
  Json.object [ ("error", Json.string message) ]
