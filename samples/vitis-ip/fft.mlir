// RUN: scalehls-opt -hlskernel-to-affine %s | FileCheck %s

// CHECK: module {
func @test_fft(%inData: memref<16x16xf32>, %outData: memref<16x16xf32>) -> () {
  "hlskernel.fft" (%inData, %outData) {IP=true} : (memref<16x16xf32>, memref<16x16xf32>) -> ()
  return
}
