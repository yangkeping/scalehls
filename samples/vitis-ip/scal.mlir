// RUN: scalehls-opt -hlskernel-to-affine %s | FileCheck %s

// CHECK: module {
func @test_scal(%alpha: f32, %x: memref<16xf32>, %xRes: memref<16xf32>) -> () {
  "hlskernel.scal" (%alpha, %x, %xRes) {IP=true} : (f32, memref<16xf32>, memref<16xf32>) -> ()
  return
}
