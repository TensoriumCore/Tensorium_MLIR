
// RUN: relativity-opt %s | FileCheck %s

func.func @foo_test(%arg0: i32) -> i32 {
  %res = relativity.foo %arg0 : i32
  return %res : i32
}

// CHECK: relativity.foo %arg0 : i32

