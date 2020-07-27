#include "uart_regs.h"
#include "uart_init.s"
#include "debug_macro.s"
#include "debug_init.s"

#define csd_LED_ADDR 0x41200000


.align 8

//Our interrupt vector table
csd_asm:
 	b csd_reset
 	b .
 	b .
 	b .
 	b .
 	b .
 	b csd_irq
 	b .

.global main
csd_reset:
main: //Instructions are described with 'C language'

	UART_init
	DEBUG_init

	DEBUG_macro				//Debug_macro #1
	ldr r0, =Input_data		//load address of Input_data
	ldr r1, =Output_data	//load address of Output_data
	DEBUG_macro				//Debug_macro #2



/*Start of Bubble sort*/
	mov r2, #0 				//set i(r2)=0
	DEBUG_macro				//Debug_macro #3
bubble_sort_for_i: 			//for loop using i(r2) : for(int i=0; i<32; i++)
	mov r3, #0 				//set j(r3)=0
	mov r7, r2				//r7 = r2
	rsb r7, r7, #31 		//set r7 to exit bubble_sort_for_j loop (r7 = #32 - #1 - i)
	mov r10, r0 			//set r10 = &r0 before entering bubble_sort_for_j loop
	DEBUG_macro				//Debug_macro #4
bubble_sort_for_j: 			//for loop using j(r3) : for(int j=0; j<32-i-1; j++)
	ldr r4, [r10] 			//r4 = *r10
	add r11, r10, #4 		//set r11 as address of value for comparing
	ldr r5, [r11] 			//r5 = *r11

	cmp r4, r5 				//compare r4, r5 -> update Condition Field
	ble bubble_sort_skip	 //if (r4<=r5), skip the instructions below
	str r4, [r11] 			//if (r4>r5)
	str r5, [r10]			 //switch the value

bubble_sort_skip:
	add r3, r3, #1 			//j(r3)++
	add r10, r10, #4 		//change address of r10 to point out next value

	cmp r3, r7				//compare r3, r7 -> update Condition Field
	blt bubble_sort_for_j 	//(j<32-i-1) : End of bubble_sort_for_j
	DEBUG_macro				//Debug_macro #5
	add r2, r2, #1			//i(r2)++
	cmp r2, #32				//compare r2, #32 -> update Condition Field
	DEBUG_macro				//Debug_macro #6
	blt bubble_sort_for_i 	//(i<32) : End of bubble_sort_for_i
/*End of Bubble sort*/

	mov r2, #32
	DEBUG_macro				//Debug_macro #7
str_Output:
	DEBUG_macro				//Debug_macro #8
	ldr r3, [r0], #4		//load a word into r3 and update r0 (= r0 + 4)
	str r3, [r1], #4		//store the word to memory and update r1 (= r1 + 4)

 	subs r2, r2, #1
 	bne str_Output

	DEBUG_macro				//Debug_macro #9

 	ldr r0, =csd_LED_ADDR
 	mov r1, #0x1
 	str r1, [r0] 			//LED for #0x1 lights on if the process come to the end

 	DEBUG_macro				//Debug_macro #10


forever:
	nop
 	b forever





.data
.align 4

Input_data:
 	.word 2, 0, -7, -1, 3, 8, -4, 10
 	.word -9, -16, 15, 13, 1, 4, -3, 14
 	.word -8, -10, -15, 6, -13, -5, 9, 12
 	.word -11, -14, -6, 11, 5, 7, -2, -12

Output_data:
	.word 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0


//Normal Interrupt Service Routine
csd_irq:
	b .
