/* Default linker script, for normal executables */
OUTPUT_FORMAT("elf32-zpu", "elf32-zpu",
	      "elf32-zpu")
OUTPUT_ARCH(zpu)
SEARCH_DIR(.);
ENTRY(_start)
SEARCH_DIR("/local/Projects/my-vssr/LEDBlink/design/tools/toolchain/lib/gcc/zpu-elf/3.4.2");
/* Do we need any of these for elf?
   __DYNAMIC = 0;    */


  MEMORY
  {
    ROM (rx) : ORIGIN = 0x00000000, LENGTH = 0x020000
    RAM (rw) : ORIGIN = 0x00020000, LENGTH = 0x013FFD
  }

SECTIONS {
.vectors : { *(.vectors) . = ALIGN(4); } > RAM
.fixed_vectors : { *(.fixed_vectors) . = ALIGN(4); } > ROM
.rodata        : { *(.rodata)        . = ALIGN(4); } > ROM
.init          : { *(.init)          . = ALIGN(4); } > ROM
.text          : { *(.text)          . = ALIGN(4); } > ROM
.fini          : { *(.fini)          . = ALIGN(4); } > ROM
.data          : { *(.data)          . = ALIGN(4); } > ROM
.ctors         : { *(.ctors)         . = ALIGN(4); } > RAM
.dtors         : { *(.dtors)         . = ALIGN(4); } > RAM
.jcr           : { *(.jcr)          . = ALIGN(4);  } > RAM
.bss           : { *(.bss)          . = ALIGN(4);  } > RAM
}

