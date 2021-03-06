// REQUIRES: x86
// RUN: llvm-mc -filetype=obj -triple=x86_64-unknown-linux %s -o %t

// Should use "_init" and "_fini" by default when fills dynamic table
// RUN: ld.lld -shared %t -o %t2
// RUN: llvm-readobj -dynamic-table %t2 | FileCheck --check-prefix=BYDEF %s
// BYDEF: INIT 0x11010
// BYDEF: FINI 0x11020

// -init and -fini override symbols to use
// RUN: ld.lld -shared %t -o %t2 -init _foo -fini _bar
// RUN: llvm-readobj -dynamic-table %t2 | FileCheck --check-prefix=OVR %s
// OVR: INIT 0x11030
// OVR: FINI 0x11040

// Check aliases as well
// RUN: ld.lld -shared %t -o %t2 -init=_foo -fini=_bar
// RUN: llvm-readobj -dynamic-table %t2 | FileCheck --check-prefix=OVR %s

// Should add a dynamic table entry even if a given symbol stay undefined
// RUN: ld.lld -shared %t -o %t2 -init=_undef -fini=_undef
// RUN: llvm-readobj -dynamic-table %t2 | FileCheck --check-prefix=UNDEF %s
// UNDEF: INIT 0x0
// UNDEF: FINI 0x0

// Should not add new entries to the symbol table
// and should not require given symbols to be resolved
// RUN: ld.lld -shared %t -o %t2 -init=_unknown -fini=_unknown
// RUN: llvm-readobj -symbols -dynamic-table %t2 | FileCheck --check-prefix=NOENTRY %s
// NOENTRY: Symbols [
// NOENTRY-NOT: Name: _unknown
// NOENTRY: ]
// NOENTRY: DynamicSection [
// NOENTRY-NOT: INIT
// NOENTRY-NOT: FINI
// NOENTRY: ]

.global _start,_init,_fini,_foo,_bar,_undef
_start:
_init = 0x11010
_fini = 0x11020
_foo  = 0x11030
_bar  = 0x11040
