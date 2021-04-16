//===----------------------------------------------------------------------===//
//
// Copyright 2020-2021 The ScaleHLS Authors.
//
//===----------------------------------------------------------------------===//

#ifndef SCALEHLS_DIALECT_HLSKERNEL_DSPOPS_TD
#define SCALEHLS_DIALECT_HLSKERNEL_DSPOPS_TD

def FFTOp : HLSKernelOp<"fft", [HLSKernelOpInterface]> {
  let summary = "fft operation";
  let description = [{}];

  let arguments = (ins
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$inData,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$outData,
    DefaultValuedAttr<BoolAttr, "false">:$IP
  );
}

#endif // SCALEHLS_DIALECT_HLSKERNEL_DSPOPS_TD