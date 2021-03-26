//===----------------------------------------------------------------------===//
//
// Copyright 2020-2021 The ScaleHLS Authors.
//
//===----------------------------------------------------------------------===//

#ifndef SCALEHLS_DIALECT_HLSCPP_VISITOR_H
#define SCALEHLS_DIALECT_HLSCPP_VISITOR_H

#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Dialect/SCF/SCF.h"
#include "scalehls/Dialect/HLSCpp/HLSCpp.h"
#include "llvm/ADT/TypeSwitch.h"

namespace mlir {
namespace scalehls {

using namespace hlscpp;

/// This class is a visitor for SSACFG operation nodes.
template <typename ConcreteType, typename ResultType, typename... ExtraArgs>
class HLSCppVisitorBase {
public:
  ResultType dispatchVisitor(Operation *op, ExtraArgs... args) {
    auto *thisCast = static_cast<ConcreteType *>(this);
    return TypeSwitch<Operation *, ResultType>(op)
        .template Case<
            // SCF statements.
            scf::ForOp, scf::IfOp, scf::ParallelOp, scf::ReduceOp,
            scf::ReduceReturnOp, scf::YieldOp,
            // Affine statements.
            AffineForOp, AffineIfOp, AffineParallelOp, AffineApplyOp,
            AffineMaxOp, AffineMinOp, AffineLoadOp, AffineStoreOp,
            AffineYieldOp, AffineVectorLoadOp, AffineVectorStoreOp,
            AffineDmaStartOp, AffineDmaWaitOp,
            // Memref-related statements.
            AllocOp, AllocaOp, LoadOp, StoreOp, DeallocOp, DmaStartOp,
            DmaWaitOp, AtomicRMWOp, GenericAtomicRMWOp, AtomicYieldOp,
            MemRefCastOp, ViewOp, SubViewOp,
            // Tensor-related statements.
            TensorLoadOp, TensorStoreOp, TensorToMemrefOp, SplatOp, DimOp,
            RankOp,
            // Unary expressions.
            AbsFOp, CeilFOp, NegFOp, CosOp, SinOp, TanhOp, SqrtOp, RsqrtOp,
            ExpOp, Exp2Op, LogOp, Log2Op, Log10Op,
            // Float binary expressions.
            CmpFOp, AddFOp, SubFOp, MulFOp, DivFOp, RemFOp,
            // Integer binary expressions.
            CmpIOp, AddIOp, SubIOp, MulIOp, SignedDivIOp, SignedRemIOp,
            UnsignedDivIOp, UnsignedRemIOp, XOrOp, AndOp, OrOp, ShiftLeftOp,
            SignedShiftRightOp, UnsignedShiftRightOp,
            // Special operations.
            SelectOp, ConstantOp, CopySignOp, TruncateIOp, ZeroExtendIOp,
            SignExtendIOp, IndexCastOp, CallOp, ReturnOp, UIToFPOp, SIToFPOp,
            FPToSIOp, FPToUIOp,
            // Structure operations.
            AssignOp, EndOp>([&](auto opNode) -> ResultType {
          return thisCast->visitOp(opNode, args...);
        })
        .Default([&](auto opNode) -> ResultType {
          return thisCast->visitInvalidOp(op, args...);
        });
  }

  /// This callback is invoked on any invalid operations.
  ResultType visitInvalidOp(Operation *op, ExtraArgs... args) {
    // op->emitOpError("is unsupported operation.");
    // abort();
    return ResultType();
  }

  /// This callback is invoked on any operations that are not handled by the
  /// concrete visitor.
  ResultType visitUnhandledOp(Operation *op, ExtraArgs... args) {
    return ResultType();
  }

#define HANDLE(OPTYPE)                                                         \
  ResultType visitOp(OPTYPE op, ExtraArgs... args) {                           \
    return static_cast<ConcreteType *>(this)->visitUnhandledOp(op, args...);   \
  }

  // SCF statements.
  HANDLE(scf::ForOp);
  HANDLE(scf::IfOp);
  HANDLE(scf::ParallelOp);
  HANDLE(scf::ReduceOp);
  HANDLE(scf::ReduceReturnOp);
  HANDLE(scf::YieldOp);

  // Affine statements.
  HANDLE(AffineForOp);
  HANDLE(AffineIfOp);
  HANDLE(AffineParallelOp);
  HANDLE(AffineApplyOp);
  HANDLE(AffineMaxOp);
  HANDLE(AffineMinOp);
  HANDLE(AffineLoadOp);
  HANDLE(AffineStoreOp);
  HANDLE(AffineYieldOp);
  HANDLE(AffineVectorLoadOp);
  HANDLE(AffineVectorStoreOp);
  HANDLE(AffineDmaStartOp);
  HANDLE(AffineDmaWaitOp);

  // Memref-related statements.
  HANDLE(AllocOp);
  HANDLE(AllocaOp);
  HANDLE(LoadOp);
  HANDLE(StoreOp);
  HANDLE(DeallocOp);
  HANDLE(DmaStartOp);
  HANDLE(DmaWaitOp);
  HANDLE(AtomicRMWOp);
  HANDLE(GenericAtomicRMWOp);
  HANDLE(AtomicYieldOp);
  HANDLE(MemRefCastOp);
  HANDLE(ViewOp);
  HANDLE(SubViewOp);

  // Tensor-related statements.
  HANDLE(TensorLoadOp);
  HANDLE(TensorStoreOp);
  HANDLE(TensorToMemrefOp);
  HANDLE(SplatOp);
  HANDLE(DimOp);
  HANDLE(RankOp);

  // Unary expressions.
  HANDLE(AbsFOp);
  HANDLE(CeilFOp);
  HANDLE(NegFOp);
  HANDLE(CosOp);
  HANDLE(SinOp);
  HANDLE(TanhOp);
  HANDLE(SqrtOp);
  HANDLE(RsqrtOp);
  HANDLE(ExpOp);
  HANDLE(Exp2Op);
  HANDLE(LogOp);
  HANDLE(Log2Op);
  HANDLE(Log10Op);

  // Float binary expressions.
  HANDLE(CmpFOp);
  HANDLE(AddFOp);
  HANDLE(SubFOp);
  HANDLE(MulFOp);
  HANDLE(DivFOp);
  HANDLE(RemFOp);

  // Integer binary expressions.
  HANDLE(CmpIOp);
  HANDLE(AddIOp);
  HANDLE(SubIOp);
  HANDLE(MulIOp);
  HANDLE(SignedDivIOp);
  HANDLE(SignedRemIOp);
  HANDLE(UnsignedDivIOp);
  HANDLE(UnsignedRemIOp);
  HANDLE(XOrOp);
  HANDLE(AndOp);
  HANDLE(OrOp);
  HANDLE(ShiftLeftOp);
  HANDLE(SignedShiftRightOp);
  HANDLE(UnsignedShiftRightOp);

  // Special operations.
  HANDLE(SelectOp);
  HANDLE(ConstantOp);
  HANDLE(CopySignOp);
  HANDLE(TruncateIOp);
  HANDLE(ZeroExtendIOp);
  HANDLE(SignExtendIOp);
  HANDLE(IndexCastOp);
  HANDLE(CallOp);
  HANDLE(ReturnOp);
  HANDLE(UIToFPOp);
  HANDLE(SIToFPOp);
  HANDLE(FPToUIOp);
  HANDLE(FPToSIOp);

  // Structure operations.
  HANDLE(AssignOp);
  HANDLE(EndOp);
#undef HANDLE
};
} // namespace scalehls
} // namespace mlir

#endif // SCALEHLS_DIALECT_HLSCPP_VISITOR_H