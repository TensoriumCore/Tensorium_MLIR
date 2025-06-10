module {
  func.func @minkowski() -> !relativity.tensor<4,4> {
    %metric = "relativity.metric"(-1.0, 1.0, 1.0, 1.0) : () -> !relativity.tensor<4,4>
    return %metric : !relativity.tensor<4,4>
  }
}
