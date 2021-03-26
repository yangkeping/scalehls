//===----------------------------------------------------------------------===//
//
// Copyright 2020-2021 The ScaleHLS Authors.
//
//===----------------------------------------------------------------------===//

#ifndef SCALEHLS_DIALECT_HLSKERNEL_BLASOPS_TD
#define SCALEHLS_DIALECT_HLSKERNEL_BLASOPS_TD

def AmaxOp : HLSKernelOp<"amax", [HLSKernelOpInterface]> {
  let summary = "amax operation";
  let description = [{}];

  let arguments = (ins
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$x,
    AnyType:$p_goldRes,
    DefaultValuedAttr<BoolAttr, "false">:$IP
  );
}

def AminOp : HLSKernelOp<"amin", [HLSKernelOpInterface]> {
  let summary = "amin operation";
  let description = [{}];

  let arguments = (ins
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$x,
    AnyType:$p_goldRes,
    DefaultValuedAttr<BoolAttr, "false">:$IP
  );
}

def AsumOp : HLSKernelOp<"asum", [HLSKernelOpInterface]> {
  let summary = "asum operation";
  let description = [{}];

  let arguments = (ins
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$x,
    AnyType:$p_goldRes,
    DefaultValuedAttr<BoolAttr, "false">:$IP
  );
}

def AxpyOp : HLSKernelOp<"axpy", [HLSKernelOpInterface]> {
  let summary = "axpy operation";
  let description = [{}];

  let arguments = (ins
    AnyType:$alpha,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$x,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$y,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$yRes,
    DefaultValuedAttr<BoolAttr, "false">:$IP
  );
}

def DotOp : HLSKernelOp<"dot", [HLSKernelOpInterface]> {
  let summary = "dot operation";
  let description = [{}];

  let arguments = (ins
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$x,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$y,
    AnyType:$p_goldRes,
    DefaultValuedAttr<BoolAttr, "false">:$IP
  );
}

def GbmvOp : HLSKernelOp<"gbmv", [HLSKernelOpInterface]> {
  let summary = "gbmv operation";
  let description = [{}];

  let arguments = (ins
    AnyType:$alpha,
    AnyType:$beta,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$a,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$x,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$y,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$yRes,
    DefaultValuedAttr<BoolAttr, "false">:$IP
  );
}

def GemmOp : HLSKernelOp<"gemm", [HLSKernelOpInterface]> {
  let summary = "gemm operation";
  let description = [{
    TRANSA (false / true): op(A) = A / op(A) = A^T,
    TRANSB (false / true): op(B) = B / op(B) = B^T,

    C = alpha * op(A) * op(B) + beta * C,

    A: M x K,
    B: K x N,
    C: M x N
  }];

  let arguments = (ins
    DefaultValuedAttr<BoolAttr, "false">:$TRANSA,
    DefaultValuedAttr<BoolAttr, "false">:$TRANSB,
    AnyType:$alpha,
    AnyType:$beta,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$A,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$B,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$C,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$R,
    DefaultValuedAttr<BoolAttr, "false">:$IP
  );
}

def GemvOp : HLSKernelOp<"gemv", [HLSKernelOpInterface]> {
  let summary = "gemv operation";
  let description = [{}];

  let arguments = (ins
    AnyType:$alpha,
    AnyType:$beta,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$a,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$x,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$y,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$yRes,
    DefaultValuedAttr<BoolAttr, "false">:$IP
  );
}

def Nrm2Op : HLSKernelOp<"nrm2", [HLSKernelOpInterface]> {
  let summary = "nrm2 operation";
  let description = [{}];

  let arguments = (ins
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$x,
    AnyType:$p_goldRes,
    DefaultValuedAttr<BoolAttr, "false">:$IP
  );
}

def ScalOp : HLSKernelOp<"scal", [HLSKernelOpInterface]> {
  let summary = "scal operation";
  let description = [{}];

  let arguments = (ins
    AnyType:$alpha,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$x,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$xRes,
    DefaultValuedAttr<BoolAttr, "false">:$IP
  );
}

def SwapOp : HLSKernelOp<"swap", [HLSKernelOpInterface]> {
  let summary = "swap operation";
  let description = [{}];

  let arguments = (ins
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$x,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$y,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$xRes,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$yRes,
    DefaultValuedAttr<BoolAttr, "false">:$IP
  );
}

def SymmOp : HLSKernelOp<"symm", [HLSKernelOpInterface]> {
  let summary = "symm operation";
  let description = [{
    SIDE (false):
    C = alpha * A * B + beta * C,
    A: M x M, symmetric,

    SIDE (true):
    C = alpha * B * A + beta * C,
    A: N x N, symmetric,

    UPLO (false / true): A is lower / upper triangular,

    B: M x N,
    C: M x N
  }];

  let arguments = (ins
    DefaultValuedAttr<BoolAttr, "false">:$SIDE,
    DefaultValuedAttr<BoolAttr, "false">:$UPLO,
    AnyType:$alpha,
    AnyType:$beta,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$A,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$B,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$C
  );
}

def SymvOp : HLSKernelOp<"symv", [HLSKernelOpInterface]> {
  let summary = "symv operation";
  let description = [{}];

  let arguments = (ins
    AnyType:$alpha,
    AnyType:$beta,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$a,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$x,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$y,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$yRes,
    DefaultValuedAttr<BoolAttr, "false">:$IP
  );
}

def SyrkOp : HLSKernelOp<"syrk", [HLSKernelOpInterface]> {
  let summary = "syrk operation";
  let description = [{
    TRANS (false):
    C = alpha * A * A^T + beta * C,
    A: N x K,

    TRANS (true):
    C = alpha * A^T * A + beta * C,
    A: K x N,

    UPLO (false / true): C is lower / upper triangular,

    C: N x N, symmetric
  }];

  let arguments = (ins
    DefaultValuedAttr<BoolAttr, "false">:$TRANS,
    DefaultValuedAttr<BoolAttr, "false">:$UPLO,
    AnyType:$alpha,
    AnyType:$beta,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$A,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$C
  );
}

def Syr2kOp : HLSKernelOp<"syr2k", [HLSKernelOpInterface]> {
  let summary = "syr2k operation";
  let description = [{
    TRANS (false):
    C = alpha * A * B^T + alpha * B * A^T + beta * C,
    A: N x K,
    B: N x K,

    TRANS (true):
    C = alpha * A^T * B + alpha * B^T * A + beta * C,
    A: K x N,
    B: K x N,

    UPLO (false / true): C is lower / upper triangular,

    C: N x N, symmetric
  }];

  let arguments = (ins
    DefaultValuedAttr<BoolAttr, "false">:$TRANS,
    DefaultValuedAttr<BoolAttr, "false">:$UPLO,
    AnyType:$alpha,
    AnyType:$beta,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$A,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$B,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$C
  );
}

def TrmmOp : HLSKernelOp<"trmm", [HLSKernelOpInterface]> {
  let summary = "trmm operation";
  let description = [{
    SIDE (false):
    B = alpha * op(A) * B,
    A: M x M, triangular,

    SIDE (true):
    B = alpha * B * op(A),
    A: N x N, triangular,

    UPLO (false / true): A is lower / upper triangular,
    TRANSA (false / true): op(A) = A / op(A) = A^T,
    DIAG (false / true): A is non-unit / unit triangular,

    B: M x N,
  }];

  let arguments = (ins
    DefaultValuedAttr<BoolAttr, "false">:$SIDE,
    DefaultValuedAttr<BoolAttr, "false">:$UPLO,
    DefaultValuedAttr<BoolAttr, "false">:$TRANSA,
    DefaultValuedAttr<BoolAttr, "false">:$DIAG,
    AnyType:$alpha,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$A,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$B
  );
}

def TrmvOp : HLSKernelOp<"trmv", [HLSKernelOpInterface]> {
  let summary = "trmv operation";
  let description = [{}];

  let arguments = (ins
    AnyType:$alpha,
    AnyType:$beta,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$a,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$x,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$y,
    AnyTypeOf<[AnyTensor, AnyMemRef]>:$yRes,
    DefaultValuedAttr<BoolAttr, "false">:$IP
  );
}

#endif // SCALEHLS_DIALECT_HLSKERNEL_BLASOPS_TD
