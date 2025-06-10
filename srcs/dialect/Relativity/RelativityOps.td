def MetricOp : Relativity_Op<"metric"> {
  let arguments = (ins F64:$t, F64:$x);
  let results = (outs Tensor2x2:$metric);
}
