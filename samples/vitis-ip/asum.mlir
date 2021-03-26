// RUN: scalehls-opt -hlskernel-to-affine %s | FileCheck %s

// CHECK: module {
func @test_asum(%x: memref<16xf32>, %res: f32) -> () {
  "hlskernel.asum" (%x, %res) {IP=true} : (memref<16xf32>, f32) -> ()
  return
}
