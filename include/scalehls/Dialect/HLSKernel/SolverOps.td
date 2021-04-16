//===----------------------------------------------------------------------===//
//
// Copyright 2020-2021 The ScaleHLS Authors.
//
//===----------------------------------------------------------------------===//

#ifndef SCALEHLS_DIALECT_HLSKERNEL_SOLVEROPS_TD
#define SCALEHLS_DIALECT_HLSKERNEL_SOLVEROPS_TD

def PSqrtOp : HLSKernelOp<"psqrt", [HLSKernelOpInterface]> {
  let summary = "pseudosqrt operation";
  let description = [{}];

  let arguments = (ins
    AnyType:$nrows,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$matIn,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$matOut,
    DefaultValuedAttr<BoolAttr, "false">:$IP
  );
}

#endif // SCALEHLS_DIALECT_HLSKERNEL_SOLVEROPS_TD