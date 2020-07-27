#define csd_LED_ADDR 0x41200000
#define csd_SW_ADDR 0x41210000


.extern csd_main

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
main:

	ldr r1, =csd_LED_ADDR	//load LED address to r1
	ldr r2, =csd_SW_ADDR	//load Switch address to r2

forever:
	bl csd_main				//set duration at the beginning of each iteration using return value saved at r0

	mov r3, #0x01			//set r3 for turning on LD0

iteration:
	mov r4, r0				//set r4 as r0

duration:
	sub r4, #0x01			//r4 = r4 - 1
	cmp r4, #0x00			//compare r4 with 0 and update Condition field
	bgt duration			//branch to duration if(r4>0) (generate time duration)

 	str r3, [r1] 			//LED for r3 lights on
	mov r3, r3,LSL #1		//r3 = r3 * 2  (r3 points next LD)
	cmp r3, #128			//if(r3<=128) loop until LD7 is on
	ble iteration			//branch to iteration

	b forever


.data
.align 4


//Normal Interrupt Service Routine
csd_irq:
	b .
