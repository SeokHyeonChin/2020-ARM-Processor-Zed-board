#define csd_SW_ADDR 0x41210000

#include "csd_zynq_peripherals.h"

.extern csd_main

.global main
main:
	ldr r11, =csd_SW_ADDR	//load Switch address to r1


forever:
	ldr r10, [r11]
	and r10, #0x1
	cmp r10, #1				// check SW0 value
	bleq cache_enable		// if SW0 is on, enable cache
	blne cache_disable		// if SW0 is off, disable cache

	bl  csd_main			// Turning on LED

	b forever

cache_disable:
	@------------------------
	@ Disable Caches (L2)
	@------------------------
	ldr r0, =L2_reg1_ctrl
	mov r1, #0x0
	str r1, [r0]
	@------------------------
	@ Disable Caches (IL1, DL1)
	@------------------------
	mrc		p15, 0, r0, c1, c0, 0	@ read control register (CP15 register1)
	bic		r0, r0, #4096		    @ disable I bit (Instruction Cache)
	bic		r0, r0, #4		        @ disable C bit (Data and Unified Caches)
	mcr		p15, 0, r0, c1, c0, 0	@ write control register (CP15 register2)

	mov pc, lr		// return to the caller

cache_enable:
	@------------------------
	@ Enable Caches (L2)
	@------------------------
	ldr r0, =L2_reg1_ctrl
    mov r1, #0x1
    str r1, [r0]

	@------------------------
	@ Enable Caches (IL1, DL1)
	@------------------------
	mrc		p15, 0, r0, c1, c0, 0	@ read control register (CP15 register1)
	orr		r0, r0, #(1<<12)	    @ Enable I bit (Instruction Cache)
	orr		r0, r0, #(1<<2)         @ Enable C bit (Data and Unified Caches)
	mcr		p15, 0, r0, c1, c0, 0	@ write control register (CP15 register2)

	mov pc, lr		// return to the caller

