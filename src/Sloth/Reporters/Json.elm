module Sloth.Reporters.Json (render) where


import List exposing (map, foldr)
import Json.Encode as Json
import Sloth.Suite as Suite
import Sloth.Data exposing (..) 


render : List (String, Data) -> String
render list =
  list
    |> map renderData
    |> Json.list
    |> Json.encode 2


renderData : (String, Data) -> Json.Value
renderData (title, data) =
  case data of
    Root ->
      Json.null
    InvalidNode message ->
      Json.object
        [ ("title", Json.string title)
        , ("result", Json.null)
        , ("message", errorMessageToJson message)
        ]
    Node _ content ->
      Json.object
        [ ("title", Json.string title)
        , ("result", contentToJson content)
        ]


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
