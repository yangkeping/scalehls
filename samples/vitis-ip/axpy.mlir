// RUN: scalehls-opt -hlskernel-to-affine %s | FileCheck %s

// CHECK: module {
func @test_axpy(%alpha: f32, %x: memref<16xf32>, %y: memref<16xf32>, %res: memref<16xf32>) -> () {
  "hlskernel.axpy" (%alpha, %x, %y, %res) {IP=true} : (f32, memref<16xf32>, memref<16xf32>, memref<16xf32>) -> ()
  return
}
