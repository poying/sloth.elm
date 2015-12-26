module SlothAssertionTest where


import Sloth exposing (..)
import Sloth.Assertion exposing (..)


tests =
  start
    `describe` "Sloth.Assertion"
      `describe` "shouldBe"
        `it` "should pass" =>
          (1 `shouldBe` 1)
        `end` 1
      `describe` "shouldNotBe"
        `it` "should pass" =>
          (1 `shouldNotBe` 2)
        `end` 1
