// RUN: relativity-opt %s | relativity-opt | FileCheck %s

module {
    // CHECK-LABEL: func @bar()
    func.func @bar() {
        %0 = arith.constant 1 : i32
        // CHECK: %{{.*}} = relativity.foo %{{.*}} : i32
        %res = relativity.foo %0 : i32
        return
    }
}
