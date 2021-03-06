/*
 * Copyright (c) 2014-2015 Wind River Systems, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @brief Common parts of the linker scripts for the ARCv2/EM targets.
 */

#define _LINKER
#define _ASMLANGUAGE

#include <autoconf.h>
#include <sections.h>

#if defined(CONFIG_NSIM)
	EXTERN(_VectorTable)
#endif

#include <linker-defs.h>
#include <linker-tool.h>

/* physical address of RAM */
#ifdef CONFIG_HARVARD
	#define ROMABLE_REGION ICCM
	#define RAMABLE_REGION DCCM
#else
	#if defined(CONFIG_XIP) && (FLASH_SIZE != 0)
		#define ROMABLE_REGION FLASH
		#define RAMABLE_REGION SRAM
	#else
		#define ROMABLE_REGION SRAM
		#define RAMABLE_REGION SRAM
	#endif
#endif

#if defined(CONFIG_XIP)
	#define _DATA_IN_ROM __data_rom_start
#else
	#define _DATA_IN_ROM
#endif

OUTPUT_ARCH(arc)
ENTRY(__start)

MEMORY {
#ifdef FLASH_START
	FLASH (rx)  : ORIGIN = FLASH_START, LENGTH = FLASH_SIZE*1k
#endif
#ifdef ICCM_START
	ICCM  (rx)  : ORIGIN = ICCM_START,  LENGTH = ICCM_SIZE*1k
#endif
#ifdef SRAM_START
	SRAM  (rwx) : ORIGIN = SRAM_START,  LENGTH = SRAM_SIZE*1k
#endif
#ifdef DCCM_START
	DCCM  (rw)  : ORIGIN = DCCM_START,  LENGTH = DCCM_SIZE*1k
#endif
}

SECTIONS {
	GROUP_START(ROMABLE_REGION)

	SECTION_PROLOGUE(_TEXT_SECTION_NAME,,ALIGN(1024)) {
		_image_rom_start = .;
		_image_text_start = .;

/* when !XIP, .text is in RAM, and vector table must be at its very start */

		KEEP(*(.exc_vector_table))
		KEEP(*(".exc_vector_table.*"))


		KEEP(*(.irq_vector_table))
		KEEP(*(".irq_vector_table.*"))

		KEEP(*(.isr_irq*))

		/*
		 * The following sections maps the location of the different
		 * rows for the _sw_isr_table. Each row maps to an IRQ entry
		 * (handler, argument).
		 *
		 * In ARC architecture, IRQ 0-15 are reserved for the system
		 * and are not * assignable by the user, for that reason the
		 * linker sections start on IRQ 16
		 */

		/* sections for IRQ16-19 */
		KEEP(*(SORT(.gnu.linkonce.isr_irq[1][6-9])))
		/* sections for IRQ20-99 */
		KEEP(*(SORT(.gnu.linkonce.isr_irq[2-9][0-9])))
		/* sections for IRQ100-999 */
		KEEP(*(SORT(.gnu.linkonce.isr_irq[1-9][0-9][0-9])))

		*(.text)
		*(".text.*")
		*(.gnu.linkonce.t.*)

		_image_text_end = .;
	} GROUP_LINK_IN(ROMABLE_REGION)

#include <linker/common-rom.ld>

	SECTION_PROLOGUE(_RODATA_SECTION_NAME,,) {
		*(.rodata)
		*(".rodata.*")
		*(.gnu.linkonce.r.*)
	} GROUP_LINK_IN(ROMABLE_REGION)

	_image_rom_end = .;
	__data_rom_start = ALIGN(4);	/* XIP imaged DATA ROM start addr */

	GROUP_END(ROMABLE_REGION)

	GROUP_START(RAMABLE_REGION)

	SECTION_DATA_PROLOGUE(_DATA_SECTION_NAME,,) {

/* when XIP, .text is in ROM, but vector table must be at start of .data */

		_image_ram_start = .;
		__data_ram_start = .;
		*(.data)
		*(".data.*")

	} GROUP_DATA_LINK_IN(RAMABLE_REGION, ROMABLE_REGION)

#include <linker/common-ram.ld>

	__data_ram_end = .;

	SECTION_PROLOGUE(_BSS_SECTION_NAME,(NOLOAD),) {
		/*
		 * For performance, BSS section is assumed to be 4 byte aligned and
		 * a multiple of 4 bytes
		 */
		. = ALIGN(4);
		__bss_start = .;
		*(.bss)
		*(".bss.*")
		COMMON_SYMBOLS
		/*
		 * BSP clears this memory in words only and doesn't clear any
		 * potential left over bytes.
		 */
		__bss_end = ALIGN(4);
	} GROUP_LINK_IN(RAMABLE_REGION)

	SECTION_PROLOGUE(_NOINIT_SECTION_NAME,(NOLOAD),) {
		/*
		 * This section is used for non-initialized objects that
		 * will not be cleared during the boot process.
		 */
		*(.noinit)
		*(".noinit.*")

	} GROUP_LINK_IN(RAMABLE_REGION)

	/* Define linker symbols */
	_image_ram_end = .;
	_end = .; /* end of image */

	GROUP_END(RAMABLE_REGION)

	/* Data Closely Coupled Memory (DCCM) */
	GROUP_START(DCCM)
	GROUP_END(DCCM)

	SECTION_PROLOGUE(initlevel_error, (OPTIONAL),)
	{
		DEVICE_INIT_UNDEFINED_SECTION()
	}
	ASSERT(SIZEOF(initlevel_error) == 0, "Undefined initialization levels used.")

	}
