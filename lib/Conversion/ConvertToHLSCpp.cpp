//===------------------------------------------------------------*- C++ -*-===//
//
//===----------------------------------------------------------------------===//

#include "Conversion/Passes.h"
#include "Dialect/HLSCpp/HLSCpp.h"
#include "mlir/Dialect/StandardOps/IR/Ops.h"
#include "mlir/Pass/Pass.h"

using namespace mlir;
using namespace scalehls;
using namespace hlscpp;

namespace {
struct ConvertToHLSCpp : public ConvertToHLSCppBase<ConvertToHLSCpp> {
public:
  void runOnOperation() override;
};
} // namespace

void ConvertToHLSCpp::runOnOperation() {
  for (auto func : getOperation().getOps<FuncOp>()) {
    auto b = OpBuilder(func);

    if (func.getBlocks().size() != 1)
      func.emitError("has zero or more than one basic blocks.");

    // Set function pragma attributes.
    func.setAttr("dataflow", b.getBoolAttr(false));

    // Insert AssignOp.
    if (auto returnOp = dyn_cast<ReturnOp>(func.front().getTerminator())) {
      b.setInsertionPoint(returnOp);
      unsigned idx = 0;
      for (auto operand : returnOp.getOperands()) {
        if (operand.getKind() == Value::Kind::BlockArgument) {
          auto value =
              b.create<AssignOp>(returnOp.getLoc(), operand.getType(), operand);
          returnOp.setOperand(idx, value);
        } else if (isa<ConstantOp>(operand.getDefiningOp())) {
          auto value =
              b.create<AssignOp>(returnOp.getLoc(), operand.getType(), operand);
          returnOp.setOperand(idx, value);
        }
        idx += 1;
      }
    } else
      func.emitError("doesn't have a return as terminator.");

    // Recursively convert every for loop body blocks.
    func.walk([&](Operation *op) {
      auto builder = OpBuilder(op);

      // ArrayOp will be inserted after each ShapedType value from declaration
      // or function signature.
      for (auto operand : op->getOperands()) {
        if (auto arrayType = operand.getType().dyn_cast<ShapedType>()) {
          bool insertArrayOp = false;
          if (operand.getKind() == Value::Kind::BlockArgument)
            insertArrayOp = true;
          else if (!isa<ArrayOp>(operand.getDefiningOp()) &&
                   !isa<AssignOp>(operand.getDefiningOp())) {
            insertArrayOp = true;
            if (!arrayType.hasStaticShape())
              operand.getDefiningOp()->emitError(
                  "is unranked or has dynamic shape which is illegal.");
          }

          if (isa<ArrayOp>(op))
            insertArrayOp = false;

          if (insertArrayOp) {
            // Insert array operation and set attributes.
            builder.setInsertionPointAfterValue(operand);
            auto arrayOp = builder.create<ArrayOp>(op->getLoc(),
                                                   operand.getType(), operand);
            operand.replaceAllUsesExcept(arrayOp.getResult(),
                                         SmallPtrSet<Operation *, 1>{arrayOp});

            // Set array pragma attributes, default array instance is ram_1p
            // bram. Other attributes are not set here since they requires more
            // analysis to be determined.
            if (!arrayOp.getAttr("interface"))
              arrayOp.setAttr("interface", builder.getBoolAttr(false));

            if (!arrayOp.getAttr("storage"))
              arrayOp.setAttr("storage", builder.getBoolAttr(false));

            if (!arrayOp.getAttr("partition"))
              arrayOp.setAttr("partition", builder.getBoolAttr(false));
          }
        }
      }

      if (auto forOp = dyn_cast<AffineForOp>(op)) {
        if (forOp.getLoopBody().getBlocks().size() != 1)
          forOp.emitError("has zero or more than one basic blocks");

        // Set loop pragma attributes.
        if (!forOp.getAttr("pipeline"))
          forOp.setAttr("pipeline", builder.getBoolAttr(false));

        if (!forOp.getAttr("unroll"))
          forOp.setAttr("unroll", builder.getBoolAttr(false));

        if (!forOp.getAttr("flatten"))
          forOp.setAttr("flatten", builder.getBoolAttr(false));
      }
    });
  }
}

std::unique_ptr<mlir::Pass> scalehls::createConvertToHLSCppPass() {
  return std::make_unique<ConvertToHLSCpp>();
}
