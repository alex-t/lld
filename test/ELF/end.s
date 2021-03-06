// Should set the value of the "_end" symbol to the end of the data segment.
// REQUIRES: x86

// RUN: llvm-mc -filetype=obj -triple=x86_64-pc-linux %s -o %t.o

// By default, the .bss section is the latest section of the data segment.
// RUN: ld.lld %t.o -o %t
// RUN: llvm-readobj -sections -symbols %t | FileCheck %s --check-prefix=DEFAULT

// DEFAULT: Sections [
// DEFAULT:     Name: .bss
// DEFAULT-NEXT:     Type:
// DEFAULT-NEXT:     Flags [
// DEFAULT-NEXT:       SHF_ALLOC
// DEFAULT-NEXT:       SHF_WRITE
// DEFAULT-NEXT:     ]
// DEFAULT-NEXT:     Address: 0x12002
// DEFAULT-NEXT:     Offset:
// DEFAULT-NEXT:     Size: 6
// DEFAULT: ]
// DEFAULT: Symbols [
// DEFAULT:     Name: _end
// DEFAULT-NEXT:     Value: 0x12008
// DEFAULT: ]

.global _start,_end
.text
_start:
    nop
.data
    .word 1
.bss
    .space 6
