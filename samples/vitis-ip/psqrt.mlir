// RUN: scalehls-opt -hlskernel-to-affine %s | FileCheck %s

// CHECK: module {
func @test_psqrt(%nrows: index, %matIn: memref<16xf32>, %matOut: memref<16xf32>) -> () {
  "hlskernel.psqrt" (%nrows, %matIn, %matOut) {IP=true} : (index, memref<16xf32>, memref<16xf32>) -> ()
  return
}
