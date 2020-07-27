#include "uart_regs.h"
#include "uart_init.s"
#include "csd_zynq_peripherals.h"

#define TIMER_INITIAL	33300000

.global main
main:
 	UART_init     // UART Initialization
 	ldr r11, =uart_TX_RX_FIFO0
	ldr r12, =uart_Channel_sts_reg0

 	// Private Timer Load Register
	ldr r0, =PRIVATE_LOAD
 	ldr r1, =TIMER_INITIAL
 	str r1, [r0]

 	// Private Timer Control Register
  	ldr r0, =PRIVATE_CONTROL
 	mov r1, #9 << 8		// Prescalar
 	orr r1, r1, #7		// IRQ Enable, Auto-Reload, Timer Enable
 	str r1, [r0]

  	ldr r0, =PRIVATE_COUNTER
  	ldr r1, =PRIVATE_STATUS
	mov	r2, #0 					// Second count 1st digit register initiation
	mov r3, #0 					// Second count 2nd digit register initiation
	mov r4, #0					// Minute count 1st digit register initiation
	mov r5, #0					// Minute count 2nd digit register initiation
	mov r6, #0					// Hour count 1st digit register initiation
	mov r7, #0					// Hour count 2nd digit register initiation

 forever:
  	cmp		r2, #10
	addeq	r3, r3, #1
	moveq	r2, #0				// Carrying in Second
	cmp		r3, #6
	addeq	r4, r4, #1
	moveq	r3, #0				// Carrying from Second to Minute

	cmp		r4, #10
	addeq	r5, r5, #1
	moveq	r4, #0				// Carrying in Minute
	cmp		r5, #6
	addeq	r6, r6, #1
	moveq	r5, #0				// Carrying from Minute to Hour

	cmp		r6, #10
	addeq	r7, r7, #1
	moveq	r6, #0				// Carrying in Hour
	cmp		r7, #6
	moveq	r6, #0
	moveq	r7, #0				// If Hour = 60, init to 0

  	bl		func_print_TIME

timer:
  	ldr 	r9, [r0]			// Read the counter value
  	ldr 	r10, [r1]			// Read the status register
	cmp		r10, #1
	bne		timer				// Makes approximately 1 second

	add		r2, r2, #1			// Second++

	mov  r12, #1
	str  r12, [r1] 				// To clear sticky bit in the status register

	b forever


func_print_TIME:
TX_loop:
	// ---------  Check to see if the Tx FIFO is empty ------------------------------
	ldr r8, [r12]		// read Channel Status Register
	and	r8, r8, #0x8	// read Transmit Buffer Empty bit(bit[3])
	cmp	r8, #0x8		// check if TxFIFO is empty and ready to receive new data
	bne	TX_loop			// if TxFIFO is NOT empty, keep checking until it is empty
	//------------------------------------------------------------------------------
	mov 	r8, #13
	strb	r8, [r11]			// Return back the cursor to the front

	add		r8, r7, #48
	strb	r8, [r11]			// Print 2nd digit of Hour
	add		r8, r6, #48
	strb	r8, [r11]			// Print 1st digit of Hour

	mov		r8, #58
	strb	r8, [r11]			// Print ':'

	add		r8, r5, #48
	strb	r8, [r11]			// Print 2nd digit of Minute
	add		r8, r4, #48
	strb	r8, [r11]			// Print 1st digit of Minute

	mov		r8, #58
	strb	r8, [r11]			// Print ':'

	add		r8, r3, #48
	strb	r8, [r11]			// Print 2nd digit of Second
	add		r8, r2, #48
	strb	r8, [r11]			// Print 1st digit of Second

	mov		pc, lr		//return to the caller
