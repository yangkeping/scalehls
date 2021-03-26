// RUN: scalehls-opt -hlskernel-to-affine %s | FileCheck %s

// CHECK: module {
func @test_dot(%x: memref<16xf32>, %y: memref<16xf32>, %res: f32) -> () {
  "hlskernel.dot" (%x, %y, %res) {IP=true} : (memref<16xf32>, memref<16xf32>, f32) -> ()
  return
}
