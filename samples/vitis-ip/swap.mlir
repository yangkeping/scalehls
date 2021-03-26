// RUN: scalehls-opt -hlskernel-to-affine %s | FileCheck %s

// CHECK: module {
func @test_swap(%x: memref<16xf32>, %y: memref<16xf32>, %xRes: memref<16xf32>, %yRes: memref<16xf32>) -> () {
  "hlskernel.swap" (%x, %y, %xRes, %yRes) {IP=true} : (memref<16xf32>, memref<16xf32>, memref<16xf32>, memref<16xf32>) -> ()
  return
}
