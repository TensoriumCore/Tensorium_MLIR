// RUN: tutorial-opt %s

module {
  func.func @main(%arg0: !relativity.relativity) -> !relativity.relativity {
    return %arg0 : !relativity.relativity
  }
}
