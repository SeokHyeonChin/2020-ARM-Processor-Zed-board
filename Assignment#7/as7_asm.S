#include "uart_regs.h"
#include "uart_init.s"
#include "csd_zynq_peripherals.h"

#define TIMER_INITIAL	33300000

.align 5

csd_vector_table:
	b .
	b .
	b .
	b .
	b .
	b .
	b csd_IRQ_ISR
	b .

.global main
main:

	// Disable interrupt: CPSR'I = 1
	cpsID i

	cps #0x12	   	       // IRQ mode
	ldr	r13,=irq_stack_top // Stack pointer setup for IRQ mode

	cps #0x1F	             // SYS mode

	// Set VBAR (Vector Base Address Register) to my vector table
	ldr     r0, =csd_vector_table
	mcr     p15, 0, r0, c12, c0, 0
	dsb
	isb

	// Enable interrupt: CPSR'I = 0
	cpsIE i

// ---------------------------
// Generic Interrupt Controller (GIC) setup - Begin
// ---------------------------

	// Distributor Control Register
	ldr r0, =GICD_CTLR
	ldr r1, [r0]
	mov r2, #1       // Enable
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

	 // Interrupt Set-Enable Register 0
	ldr r0, =GICD_ISENABLER0
	ldr r1, [r0]
	mov r2, #1 << 29   // Enable #29 (Private Timer)
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

	// According to specifications,
	// Cortex-A9 supports 5-bit version of priority format [7:3] in secure world
	// ( 0 -> 8 -> 16 -> 24...)

	// Interrupt Priority Register #7
	ldr r0, =GICD_PRIOR7
	ldr r1, [r0]
	mov r2, #0x10 << 8    // Priority 16 for ID# 29 (Private Timer)
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

	// CPU Interface Control Register
	ldr r0, =GICC_CTLR
	ldr r1, [r0]
	mov r2, #1        // Enable
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

 	// CPU Interface Interrupt Priority Mask Register
	ldr r0, =GICC_PMR
	ldr r1, [r0]
	mov r2, #0xFF     // Lowest
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

// ---------------------------
// Generic Interrupt Controller (GIC) setup - End
// ---------------------------


// ---------------------------
// Private Timer setup - Begin
// ---------------------------

 	UART_init     // UART Initialization

 	// Private Timer Load Register
	ldr r0, =PRIVATE_LOAD
 	ldr r1, =TIMER_INITIAL
 	str r1, [r0]

 	// Private Timer Control Register
  	ldr r0, =PRIVATE_CONTROL
 	mov r1, #9 << 8   // Prescalar
 	orr r1, r1, #7     // IRQ Enable, Auto-Reload, Timer Enable
 	str r1, [r0]

// ----------------------------
// Private Timer setup - End
// ----------------------------


	ldr r0, =PRIVATE_COUNTER
	ldr r1, =PRIVATE_STATUS
	ldr r2, =GICD_ISPENDR0

	ldr r11, =uart_TX_RX_FIFO0
	ldr r12, =uart_Channel_sts_reg0

TX_loop:
	// ---------  Check to see if the Tx FIFO is empty ------------------------------
	ldr r8, [r12]		// read Channel Status Register
	and	r8, r8, #0x8	// read Transmit Buffer Empty bit(bit[3])
	cmp	r8, #0x8		// check if TxFIFO is empty and ready to receive new data
	bne	TX_loop			// if TxFIFO is NOT empty, keep checking until it is empty
	//------------------------------------------------------------------------------

//Print '00:00:00' at the start
	mov 	r8, #13
	strb	r8, [r11]			// Return back the cursor to the front
	mov		r8, #48
	strb	r8, [r11]			// Print '0'
	strb	r8, [r11]			// Print '0'
	mov		r8, #58
	strb	r8, [r11]			// Print ':'
	mov		r8, #48
	strb	r8, [r11]			// Print '0'
	strb	r8, [r11]			// Print '0'
	mov		r8, #58
	strb	r8, [r11]			// Print ':'
	mov		r8, #48
	strb	r8, [r11]			// Print '0'
	strb	r8, [r11]			// Print '0'
	mov		r8, #58

forever:
	ldr r5, [r0]
	ldr r6, [r1]
	ldr r7, [r2]
	b forever


// ----------------------------
// Interrupt Service Routines (ISRs) - Begin
// ----------------------------

csd_IRQ_ISR:

	stmfd sp!, {r0-r12, lr}

 	// Interrupt Ack
  	ldr r0, =GICC_IAR
	ldr r10, [r0]

	bl as7_main

	ldr r1, [r0], #4		// Set r1 as 2nd digit of Hour - a[0]
	ldr r2, [r0], #4		// Set r2 as 1st digit of Hour - a[1]
	ldr r3, [r0], #4		// Set r3 as 2nd digit of Minute - a[2]
	ldr r4, [r0], #4		// Set r4 as 1st digit of Minute - a[3]
	ldr r5, [r0], #4		// Set r5 as 2nd digit of Second - a[4]
	ldr r6, [r0]			// Set r6 as 1st digit of Second - a[5]

	mov 	r8, #13
	strb	r8, [r11]			// Return back the cursor to the front

	add		r8, r1, #48
	strb	r8, [r11]			// Print 2nd digit of Hour
	add		r8, r2, #48
	strb	r8, [r11]			// Print 1st digit of Hour

	mov		r8, #58
	strb	r8, [r11]			// Print ':'

	add		r8, r3, #48
	strb	r8, [r11]			// Print 2nd digit of Minute
	add		r8, r4, #48
	strb	r8, [r11]			// Print 1st digit of Minute

	mov		r8, #58
	strb	r8, [r11]			// Print ':'

	add		r8, r5, #48
	strb	r8, [r11]			// Print 2nd digit of Second
	add		r8, r6, #48
	strb	r8, [r11]			// Print 1st digit of Second

 	// Clear Interrupt Status bit
  	ldr r0, =PRIVATE_STATUS
  	mov r1, #1
	str r1, [r0]


 	// End-of-Interrupt
  	ldr r0, =GICC_EOIR
	str r10, [r0]

	ldmfd sp!, {r0-r12, lr}
	subs pc, lr, #4

// ----------------------------
// Interrupt Service Routines (ISRs) - End
// ----------------------------

.data
.align 4

irq_stack:     .space 1024
irq_stack_top:


