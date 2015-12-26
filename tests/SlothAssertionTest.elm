module SlothAssertionTest where


import Sloth exposing (..)
import Sloth.Assertion exposing (..)


tests =
  start
    `describe` "Sloth.Assertion"
      `describe` "shouldBe"
        `it` "should fail" =>
          (1 `shouldBe` 2)
        `it` "should success" =>
          (1 `shouldBe` 1)
        `end` 1
      `describe` "shouldNotBe"
        `it` "should fail" =>
          (1 `shouldNotBe` 1)
        `it` "should success" =>
          (1 `shouldNotBe` 2)
        `end` 1
