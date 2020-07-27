#include "uart_regs.h"
#include "uart_init.s"
#include "csd_zynq_peripherals.h"

#define	TIMER_INITIAL	333000

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

	cps #0x13		          // supervisor mode

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

 	// Private Timer Load Register
	ldr r0, =PRIVATE_LOAD
 	ldr r1, =TIMER_INITIAL
 	str r1, [r0]

 	// Private Timer Control Register
  	ldr r0, =PRIVATE_CONTROL
 	mov r1, #9 << 8  	// Prescalar
 	orr r1, r1, #7 		// IRQ Enable, Auto-Reload, Timer Enable
 	str r1, [r0]

// ----------------------------
// Private Timer setup - End
// ----------------------------


// ---------------------------
// UART Configuration - Begin
// ---------------------------
	UART_init     // UART Initialization
	ldr r11, =uart_TX_RX_FIFO0
	ldr r12, =uart_Channel_sts_reg0

TX_loop:
	// ---------  Check to see if the Tx FIFO is empty ------------------------------
	ldr r1, [r12]		// read Channel Status Register
	and	r1, r1, #0x8	// read Transmit Buffer Empty bit(bit[3])
	cmp	r1, #0x8		// check if TxFIFO is empty and ready to receive new data
	bne	TX_loop			// if TxFIFO is NOT empty, keep checking until it is empty
	//------------------------------------------------------------------------------
// ----------------------------
// UART Configuration - End
// ----------------------------


// ---------------------------
// TCB(Task-Control Block) Setup - Begin
// ---------------------------
	ldr r0,=task1_Pointer
	add r0, r0, #52
	ldr	r1,=task1_stack_top
	str r1, [r0]				// task1 TCB Stack setup

	ldr r2,=task1_TCB

	mrs r3, cpsr			 	// read CPSR
	mvn r4, #0x1f
	and r5, r3, r4				// Clear M[4:0] in CPSR
	orr	r5, r5, #0x10			// 0x10: User mode
	str r5, [r2]				// task1 TCB spsr initiation with User mode bit

	add r2, r2, #4
	ldr r3,=task1_c
	str r3, [r2]				// task1 TCB lr setup



	ldr r0,=task2_Pointer
	add r0, r0, #52
	ldr	r1,=task2_stack_top
	str r1, [r0]				// task2 TCB Stack setup

	ldr r2,=task2_TCB
	str r5, [r2]				// task2 TCB spsr initiation with User mode bit

	add r2, r2, #4
	ldr r3,=task2_c
	add r3, r3, #4
	str r3, [r2]				// task2 TCB lr setup



	ldr r0,=task3_Pointer
	add r0, r0, #52
	ldr	r1,=task3_stack_top
	str r1, [r0]				// task3 TCB Stack setup

	ldr r2,=task3_TCB
	str r5, [r2]				// task3 TCB spsr initiation with User mode bit

	add r2, r2, #4
	ldr r3,=task3_c
	add r3, r3, #4
	str r3, [r2]				// task3 TCB lr setup
// ---------------------------
// TCB(Task-Control Block) Setup - End
// ---------------------------


	cps  #0x10   // Change to User Mode

	b task1_c



 csd_IRQ_ISR:
 	ldr sp,=irq_stack_top			// set sp as stack for IRQ_ISR
	stmfd sp!, {r0-lr}^				// save r0-lr of recently executed task in IRQ stack
	mrs r10, spsr					// save cpsr of recently executed task in r10 (Which is saved in SPSR_IRQ)
	mov r11, lr						// save lr(return location from recently executed task) in r11

 	ldr r1, =round_robin_flag
	ldr r2, [r1]					// check the flag to find out which task is next

	cmp r2, #0
	beq from_task1

	cmp r2, #1
	beq from_task2

	cmp r2, #2
	beq from_task3


from_task1:
	ldr r9,=task1_TCB
	str r10, [r9]				// store value of spsr to task1_TCB SPSR
	add r9, r9, #4
	str r11, [r9]				// store value of lr(return location) to task1_TCB lr

	ldmfd sp!, {r0-r11}			// get data of r0-r11 from irq_stack
	mov r12, sp					// save SP_IRQ in r12
	ldr sp,=task1_Pointer		// switch sp to task1_Pointer
	stmea sp, {r0-r11}			// save r0-r11 to task1_Pointer(TCB)
	mov sp, r12					// restore SP_IRQ from r12
	ldmfd sp!, {r0-r2}			// get data of r12,sp,lr from irq_stack to r0-r2
	ldr r10,=task1_Pointer
	add r10, r10, #48			// r10 points address of r12 int task1_TCB
	mov sp, r10
	stmea sp, {r0-r2}			// save r0-r2 (which is r12, sp, lr of task1) to task1_Pointer(TCB)


	ldr r1, =round_robin_flag
	mov r2, #1
	str r2, [r1]				// set round_robin_flag to 1

	// Interrupt Ack
  	ldr r0, =GICC_IAR
	ldr r3, [r0]

	// Clear Interrupt Status bit
  	ldr r0, =PRIVATE_STATUS
  	mov r1, #1
	str r1, [r0]

 	// End-of-Interrupt
  	ldr r0, =GICC_EOIR
	str r3, [r0]

	ldr r9,=task2_TCB
	ldr r10, [r9]
	msr spsr, r10				// switch SPSR_IRQ to SPSR of Task2

	add r9, r9, #4				// get address of lr in task2_TCB
	ldr lr, [r9]				// switch lr to lr in task2_TCB

	ldr sp,=task2_Pointer
	ldmfd sp, {r0-lr}^			// set reg to execute Task2

	subs pc, lr, #4 			// execute task2


from_task2:
	ldr r9,=task2_TCB
	str r10, [r9]				// store value of spsr to task2_TCB SPSR
	add r9, r9, #4
	str r11, [r9]				// store value of lr(return location) to task2_TCB lr

	ldmfd sp!, {r0-r11}			// get data of r0-r11 from irq_stack
	mov r12, sp					// save SP_IRQ in r12
	ldr sp,=task2_Pointer		// switch sp to task2_Pointer
	stmea sp, {r0-r11}			// save r0-r11 to task2_Pointer(TCB)
	mov sp, r12					// restore SP_IRQ from r12
	ldmfd sp!, {r0-r2}			// get data of r12,sp,lr from irq_stack to r0-r2
	ldr r10,=task2_Pointer
	add r10, r10, #48			// r10 points address of r12 int task2_TCB
	mov sp, r10
	stmea sp, {r0-r2}			// save r0-r2 (which is r12, sp, lr of task2) to task2_Pointer(TCB)


	ldr r1, =round_robin_flag
	mov r2, #2
	str r2, [r1]				// set round_robin_flag to 2

	// Interrupt Ack
  	ldr r0, =GICC_IAR
	ldr r3, [r0]

	// Clear Interrupt Status bit
  	ldr r0, =PRIVATE_STATUS
  	mov r1, #1
	str r1, [r0]

 	// End-of-Interrupt
  	ldr r0, =GICC_EOIR
	str r3, [r0]

	ldr r9,=task3_TCB
	ldr r10, [r9]
	msr spsr, r10				// switch SPSR_IRQ to SPSR of Task3

	add r9, r9, #4				// get address of lr in task3_TCB
	ldr lr, [r9]				// switch lr to lr in task3_TCB

	ldr sp,=task3_Pointer
	ldmfd sp, {r0-lr}^			// set reg to execute Task3

	subs pc, lr, #4 			// execute task3

from_task3:
	ldr r9,=task3_TCB
	str r10, [r9]				// store value of spsr to task3_TCB SPSR
	add r9, r9, #4
	str r11, [r9]				// store value of lr(return location) to task3_TCB lr

	ldmfd sp!, {r0-r11}			// get data of r0-r11 from irq_stack
	mov r12, sp					// save SP_IRQ in r12
	ldr sp,=task3_Pointer		// switch sp to task3_Pointer
	stmea sp, {r0-r11}			// save r0-r11 to task3_Pointer(TCB)
	mov sp, r12					// restore SP_IRQ from r12
	ldmfd sp!, {r0-r2}			// get data of r12,sp,lr from irq_stack to r0-r2
	ldr r10,=task3_Pointer
	add r10, r10, #48			// r10 points address of r12 int task3_TCB
	mov sp, r10
	stmea sp, {r0-r2}			// save r0-r2 (which is r12, sp, lr of task3) to task3_Pointer(TCB)


	ldr r1, =round_robin_flag
	mov r2, #0
	str r2, [r1]				// set round_robin_flag to 0

	// Interrupt Ack
  	ldr r0, =GICC_IAR
	ldr r3, [r0]

	// Clear Interrupt Status bit
  	ldr r0, =PRIVATE_STATUS
  	mov r1, #1
	str r1, [r0]

 	// End-of-Interrupt
  	ldr r0, =GICC_EOIR
	str r3, [r0]

	ldr r9,=task1_TCB
	ldr r10, [r9]
	msr spsr, r10				// switch SPSR_IRQ to SPSR of Task1

	add r9, r9, #4				// get address of lr in task1_TCB
	ldr lr, [r9]				// switch lr to lr in task1_TCB

	ldr sp,=task1_Pointer
	ldmfd sp, {r0-lr}^			// set reg to execute Task1

	subs pc, lr, #4 			// execute task1




.data
.align 4

irq_stack:     .space 1024
irq_stack_top:

task1_stack:     .space 1024
task1_stack_top:
task2_stack:     .space 1024
task2_stack_top:
task3_stack:     .space 1024
task3_stack_top:

task1_TCB:
	.word 0,0
task1_Pointer:
	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
task2_TCB:
	.word 0,0
task2_Pointer:
	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
task3_TCB:
	.word 0,0
task3_Pointer:
	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

round_robin_flag:
	.word 0
