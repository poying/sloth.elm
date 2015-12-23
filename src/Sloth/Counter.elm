module Sloth.Counter where


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
