; RUN: llvm-as -o %t1.bc %s
; RUN: llvm-as -o %t2.bc %S/Inputs/irmover-error.ll
; RUN: not ld.lld -m elf_x86_64 %t1.bc %t2.bc -o %t 2>&1 | FileCheck %s

; CHECK: failed to link module {{.*}}2.bc: linking module flags 'foo': IDs have conflicting values

target triple = "x86_64-unknown-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

!0 = !{ i32 1, !"foo", i32 1 }

!llvm.module.flags = !{ !0 }
