// RUN: scalehls-opt -hlskernel-to-affine %s | FileCheck %s

// CHECK: module {
func @test_amax(%x: memref<16xf32>, %res: f32) -> () {
  "hlskernel.amax" (%x, %res) {IP=true} : (memref<16xf32>, f32) -> ()
  return
}
