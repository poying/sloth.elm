module Sloth.Data where


import Sloth.Suite as Suite
import Maybe exposing (Maybe(Just, Nothing))
import Graphics.Element exposing (Element, show)


type Data
  = Node Data Suite.Content
  | Root
  | InvalidNode String


appendContent : Data -> Suite.Content -> Data
appendContent data content = 
  case data of
    Node parentSloth parentContent ->
      let
        result = Suite.appendChild parentContent content
      in
        case result of
          Ok newContent ->
            Node parentSloth newContent
          Err message ->
            InvalidNode message
    Root ->
      InvalidNode "This will never happen."
    InvalidNode _ ->
      data
