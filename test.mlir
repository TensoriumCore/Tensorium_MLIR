module {
  func.func @main() {
    %g = mydialect.metric "kerr_metric" : tensor<4x4xf64>
    %g1 = mydialect.metric "kerr" : tensor<4x4xf64>
    return
  }
}
