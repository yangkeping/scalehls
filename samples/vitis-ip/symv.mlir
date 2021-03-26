// RUN: scalehls-opt -hlskernel-to-affine %s | FileCheck %s

// CHECK: module {
func @test_symv(%alpha: f32, %beta: f32, %a: memref<16xf32>, %x: memref<16xf32>, %y: memref<16xf32>, %yRes: memref<16xf32>) -> () {
  "hlskernel.symv" (%alpha, %beta, %a, %x, %y, %yRes) {IP=true} : (f32, f32, memref<16xf32>, memref<16xf32>, memref<16xf32>, memref<16xf32>) -> ()
  return
}
