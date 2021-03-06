; REQUIRES: x86
; RUN: llvm-as %s -o %t.o
; RUN: llvm-mc %p/Inputs/unnamed-addr-lib.s -o %t2.o -filetype=obj -triple=x86_64-pc-linux
; RUN: ld.lld %t2.o -shared -o %t2.so
; RUN: ld.lld -m elf_x86_64 %t.o %t2.so -o %t.so -save-temps -shared
; RUN: llvm-dis %t.so.lto.bc -o - | FileCheck %s

; This documents a small limitation of lld's internalization logic. We decide
; that bar should be in the symbol table because if it is it will preempt the
; one in the shared library.
; We could add one extra bit for ODR so that we know that preemption is not
; necessary, but that is probably not worth it.

; CHECK: @foo = internal constant i8 42
; CHECK: @bar = weak_odr constant i8 42

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@foo = linkonce_odr unnamed_addr constant i8 42
@bar = linkonce_odr unnamed_addr constant i8 42
