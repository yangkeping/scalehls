// RUN: scalehls-opt -hlskernel-to-affine %s | FileCheck %s

// CHECK: module {
func @test_nrm2(%x: memref<16xf32>, %res: f32) -> () {
  "hlskernel.nrm2" (%x, %res) {IP=true} : (memref<16xf32>, f32) -> ()
  return
}
