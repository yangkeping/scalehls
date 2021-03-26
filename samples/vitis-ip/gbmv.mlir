// RUN: scalehls-opt -hlskernel-to-affine %s | FileCheck %s

// CHECK: module {
func @test_gbmv(%alpha: f32, %beta: f32, %a: memref<8192xf32>, %x: memref<1024xf32>, %y: memref<1024xf32>, %res: memref<1024xf32>) -> () {
  "hlskernel.gbmv" (%alpha, %beta, %a, %x, %y, %res) {IP=true} : (f32, f32, memref<8192xf32>, memref<1024xf32>, memref<1024xf32>, memref<1024xf32>) -> ()
  return
}
