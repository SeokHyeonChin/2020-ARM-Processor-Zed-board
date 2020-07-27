#include "uart_regs.h"
#include "uart_init.s"

#define csd_LED_ADDR 0x41200000

.align 8

// Our interrupt vector table
csd_entry:
	b csd_reset
	b .
	b .
	b .
	b .
	b .
	b .
	b .

.global main
.global csd_entry
csd_reset:
main:

	UART_init     // UART Initialization

	ldr r9, =csd_LED_ADDR	//load LED address to r93
	ldr r10, =uart_TX_RX_FIFO0
	ldr r11, =uart_Channel_sts_reg0


	bl UART_Selection		//print selection table

check_input:
	// check empty: bit#1 is Rx FIFO empty or not (1: empty, 0: not empty)
	ldr r1, [r11]
	and r1, r1, #1<<1
	cmp r1, #0b10
	beq check_input

	// read data and transmit it back to sender
	ldr r2, [r10]
	str r2, [r10]

call_C_code:
	mov r0, r2				//set r0 as r2 to give argument to C code
	bl as4_main				//set duration at the beginning of each iteration using return value saved at r0

	//if wrong input is detected branch to check_input to get input again
	cmp r0, #1
	bleq UART_WrongInput
	beq check_input

	bl UART_Selection		//Print selection table for next input

forever:
	mov r3, #0x01			//set r3 for turning on LD0
	mov r8, #0				//set r8 as 0 <- r8 is used to check input while executing iteration after printing selection table
iteration:
	mov r4, r0				//set r4 as r0

	//check empty at every start of turning on LED
	ldr r1, [r11]
	and r1, r1, #1<<1
	cmp r1, #0b10
	movne r8, #1
	ldrne r2, [r10]
	strne r2, [r10]

duration:
	sub r4, #0x01			//r4 = r4 - 1
	cmp r4, #0x00			//compare r4 with 0 and update Condition field
	bgt duration			//branch to duration if(r4>0) (generate time duration)
//end of duration
 	str r3, [r9] 			//LED for r3 lights on
	mov r3, r3,LSL #1		//r3 = r3 * 2  (r3 points next LD)
	cmp r3, #128			//if(r3<=128) loop until LD7 is on
	ble iteration			//branch to iteration
//end of iteration

	//Check r8 to catch if next input is entered
	cmp r8, #1
	beq call_C_code			//If r8 is 1, it means next input is entered, and the input is in r2.

	b forever				//if no next input, start iteration with same duration




//For printing Selection table
UART_Selection:

	ldr 	r1, =string

TX_loop:
	// ---------  Check to see if the Tx FIFO is empty ------------------------------
	ldr r2, [r11]		// read Channel Status Register
	and	r2, r2, #0x8	// read Transmit Buffer Empty bit(bit[3])
	cmp	r2, #0x8		// check if TxFIFO is empty and ready to receive new data
	bne	TX_loop			// if TxFIFO is NOT empty, keep checking until it is empty
	//------------------------------------------------------------------------------

	ldrb	r3, [r1], #1
	strb	r3, [r10]	// fill the TxFIFO with 0x48
	cmp     r3, #0x00
	bne		TX_loop

	mov		pc, lr		// return to the caller


//For Wrong input
UART_WrongInput:

	ldr 	r1, =string2
	b TX_loop			//Since printing to Tera Term is implemented, use it.



	.data
string:
	.byte 0x0D
	.byte 0x0A
	.ascii "----------------- LED On Duration ----------------"
	.byte 0x0D
	.byte 0x0A
	.ascii "1. 100ms 2. 200ms 3. 300ms 4. 400 ms"
	.byte 0x0D
	.byte 0x0A
	.ascii "5. 500ms 6. 600ms 7. 700ms 8. 1 sec"
	.byte 0x0D
	.byte 0x0A
	.ascii "---------------------------------------------------"
	.byte 0x0D
	.byte 0x0A
	.ascii "Select:"
	.byte 0x0D
	.byte 0x0A
	.byte 0x00

string2:
	.byte 0x0D
	.byte 0x0A
	.ascii "You inserted wrong! Please choose numbers between 0 and 8!!!!!"
	.byte 0x0D
	.byte 0x0A
	.byte 0x00


