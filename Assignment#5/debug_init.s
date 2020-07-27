.macro DEBUG_init
debug_initiation:
	b	end		//For function use, declare functions

debug_macro_start:
	//	r0	= cpsr
	ldr r10, =uart_TX_RX_FIFO0
	ldr r11, =uart_Channel_sts_reg0
	//	r12 = stack_base
/* cpsr = *(stack_base), r15 = *(stack_base + 0x04), r0 = *(stack_base + 0x08) ...
  r11 = *(stack_base + 0x34), r12 = *(stack_base + 0x38), r14 = *(stack_base + 0x3c)
  while r13 = stack_base + 0x40 															*/

	bl func_print_LINE	//print '-'

	mov 	r3, #13
	strb	r3, [r10]
	mov 	r3, #10
	strb	r3, [r10]	//print enter

	// ---------  Print info. about register r0---------------------------
	mov 	r1, #0														//
	bl		func_print_r0_r9	//print 'r* =0x' using r1

	add		r2, r12, #0x8		//r0 = *(stack_base + 0x08) -> set to r2
	mov		r1, r2
	bl		func_REG_PRINT		//print value of register in Hex with r1//
	// -------------------------------------------------------------------

	mov 	r3, #44
	strb	r3, [r10]	//print ','
	mov 	r3, #32
	strb	r3, [r10]	//print space

	// ---------  Print info. about register r1---------------------------
	mov 	r1, #1														//
	bl		func_print_r0_r9	//print 'r* =0x' using r1

	add		r2, r2, #0x4		//r1 = *(stack_base + 0x0c) -> r2 + 0x4
	mov		r1, r2
	bl		func_REG_PRINT		//print value of register in Hex with r1//
	// -------------------------------------------------------------------

	mov 	r3, #44
	strb	r3, [r10]	//print ','
	mov 	r3, #32
	strb	r3, [r10]	//print space

	// ---------  Print info. about register r2---------------------------
	mov 	r1, #2														//
	bl		func_print_r0_r9

	add		r2, r2, #0x4
	mov		r1, r2
	bl		func_REG_PRINT												//
	// -------------------------------------------------------------------

	mov 	r3, #44
	strb	r3, [r10]	//print ','
	mov 	r3, #32
	strb	r3, [r10]	//print space

	// ---------  Print info. about register r3---------------------------
	mov 	r1, #3														//
	bl		func_print_r0_r9

	add		r2, r2, #0x4
	mov		r1, r2
	bl		func_REG_PRINT												//
	// -------------------------------------------------------------------

	mov 	r3, #13
	strb	r3, [r10]
	mov 	r3, #10
	strb	r3, [r10]	//print enter

	// ---------  Print info. about register r4---------------------------
	mov 	r1, #4														//
	bl		func_print_r0_r9

	add		r2, r2, #0x4
	mov		r1, r2
	bl		func_REG_PRINT												//
	// -------------------------------------------------------------------

	mov 	r3, #44
	strb	r3, [r10]	//print ','
	mov 	r3, #32
	strb	r3, [r10]	//print space

	// ---------  Print info. about register r5---------------------------
	mov 	r1, #5														//
	bl		func_print_r0_r9

	add		r2, r2, #0x4
	mov		r1, r2
	bl		func_REG_PRINT												//
	// -------------------------------------------------------------------

	mov 	r3, #44
	strb	r3, [r10]	//print ','
	mov 	r3, #32
	strb	r3, [r10]	//print space

	// ---------  Print info. about register r6---------------------------
	mov 	r1, #6														//
	bl		func_print_r0_r9

	add		r2, r2, #0x4
	mov		r1, r2
	bl		func_REG_PRINT												//
	// -------------------------------------------------------------------

	mov 	r3, #44
	strb	r3, [r10]	//print ','
	mov 	r3, #32
	strb	r3, [r10]	//print space

	// ---------  Print info. about register r7---------------------------
	mov 	r1, #7														//
	bl		func_print_r0_r9

	add		r2, r2, #0x4
	mov		r1, r2
	bl		func_REG_PRINT												//
	// -------------------------------------------------------------------

	mov 	r3, #13
	strb	r3, [r10]
	mov 	r3, #10
	strb	r3, [r10]	//print enter

	// ---------  Print info. about register r8---------------------------
	mov 	r1, #8														//
	bl		func_print_r0_r9

	add		r2, r2, #0x4
	mov		r1, r2
	bl		func_REG_PRINT												//
	// -------------------------------------------------------------------

	mov 	r3, #44
	strb	r3, [r10]	//print ','
	mov 	r3, #32
	strb	r3, [r10]	//print space

	// ---------  Print info. about register r9---------------------------
	mov 	r1, #9														//
	bl		func_print_r0_r9

	add		r2, r2, #0x4
	mov		r1, r2
	bl		func_REG_PRINT												//
	// -------------------------------------------------------------------

	mov 	r3, #44
	strb	r3, [r10]	//print ','
	mov 	r3, #32
	strb	r3, [r10]	//print space

	// ---------  Print info. about register r10---------------------------
	mov 	r1, #0														//
	bl		func_print_r10_r15		//print 'r1* =0x' using r1

	add		r2, r2, #0x4
	mov		r1, r2
	bl		func_REG_PRINT												//
	// -------------------------------------------------------------------

	mov 	r3, #44
	strb	r3, [r10]	//print ','
	mov 	r3, #32
	strb	r3, [r10]	//print space

	// ---------  Print info. about register r11---------------------------
	mov 	r1, #1														//
	bl		func_print_r10_r15		//print 'r1* =0x' using r1

	add		r2, r2, #0x4
	mov		r1, r2
	bl		func_REG_PRINT												//
	// -------------------------------------------------------------------

	mov 	r3, #13
	strb	r3, [r10]
	mov 	r3, #10
	strb	r3, [r10]	//print enter

	// ---------  Print info. about register r12---------------------------
	mov 	r1, #2														//
	bl		func_print_r10_r15

	add		r2, r2, #0x4
	mov		r1, r2
	bl		func_REG_PRINT												//
	// -------------------------------------------------------------------

	mov 	r3, #44
	strb	r3, [r10]	//print ','
	mov 	r3, #32
	strb	r3, [r10]	//print space

	// ---------  Print info. about register r13---------------------------
	mov 	r1, #3														//
	bl		func_print_r10_r15

	add		r3, r12, #0x40	//r13 = stack_base + 0x40
	PUSH	{r3}
	mov		r1, sp			//func_REG_PRINT implemented using memory address
	bl		func_REG_PRINT	//To use memory address, push & pop
	POP		{r3}														//
	// -------------------------------------------------------------------

	mov 	r3, #44
	strb	r3, [r10]	//print ','
	mov 	r3, #32
	strb	r3, [r10]	//print space

	// ---------  Print info. about register r14---------------------------
	mov 	r1, #4														//
	bl		func_print_r10_r15

	add		r2, r2, #0x4
	mov		r1, r2
	bl		func_REG_PRINT												//
	// -------------------------------------------------------------------

	mov 	r3, #44
	strb	r3, [r10]	//print ','
	mov 	r3, #32
	strb	r3, [r10]	//print space

	// ---------  Print info. about register r15---------------------------
	mov 	r1, #5														//
	bl		func_print_r10_r15

	add		r1, r12, #0x4	//r15 = *(stack_base + 0x04)
	bl		func_REG_PRINT												//
	// -------------------------------------------------------------------

	mov 	r3, #13
	strb	r3, [r10]
	mov 	r3, #10
	strb	r3, [r10]	//print enter

	// ---------  Print info. about register CPSR---------------------------
	mov 	r3, #99
	strb	r3, [r10]	//print 'c'
	mov 	r3, #112
	strb	r3, [r10]	//print 'p'
	mov 	r3, #115
	strb	r3, [r10]	//print 's'
	mov 	r3, #114
	strb	r3, [r10]	//print 'r'
	mov 	r3, #61
	strb	r3, [r10]	//print '='
	mov 	r3, #32
	strb	r3, [r10]	//print space

	bl		func_print_NZCV		//print NZCV of cpsr

	mov 	r3, #44
	strb	r3, [r10]	//print ','
	mov 	r3, #32
	strb	r3, [r10]	//print space

	bl		func_print_IF		//print IF of cpsr

	bl		func_print_JT		//print JT of cpsr

	mov 	r3, #32
	strb	r3, [r10]	//print space
	mov 	r3, #109
	strb	r3, [r10]	//print 'm'
	mov 	r3, #111
	strb	r3, [r10]	//print 'o'
	mov 	r3, #100
	strb	r3, [r10]	//print 'd'
	mov 	r3, #101
	strb	r3, [r10]	//print 'e'
	mov 	r3, #44
	strb	r3, [r10]	//print ','
	mov 	r3, #32
	strb	r3, [r10]	//print space

	bl		func_print_MODE		//print MODE of cpsr

	mov 	r3, #32
	strb	r3, [r10]	//print space
	mov 	r3, #40
	strb	r3, [r10]	//print '('
	mov 	r3, #32
	strb	r3, [r10]	//print space
	mov 	r3, #61
	strb	r3, [r10]	//print '='
	mov 	r3, #48
	strb	r3, [r10]	//print '0'
	mov 	r3, #120
	strb	r3, [r10]	//print 'x'

	mov		r1, r12
	bl		func_REG_PRINT		//print cpsr in Hex

	mov 	r3, #41
	strb	r3, [r10]	//print ')'
	mov 	r3, #13
	strb	r3, [r10]
	mov 	r3, #10
	strb	r3, [r10]	//print enter

	bl		func_print_LINE		//print '-'

	mov 	r3, #13
	strb	r3, [r10]
	mov 	r3, #10
	strb	r3, [r10]	//print enter

	POP	{pc}			//Go back to DEBUG_macro



//FUNCTION: Print '-' * 70
func_print_LINE:
	mov 	r2, #70
func_print_LINE_1:
	mov 	r3, #45				//set r3 as ASCII of '-'
	// ---------  Check to see if the Tx FIFO is empty ------------------------------
func_print_LINE_TX_loop:
	ldr r9, [r11]				// read Channel Status Register
	and	r9, r9, #0x8			// read Transmit Buffer Empty bit(bit[3])
	cmp	r9, #0x8				// check if TxFIFO is empty and ready to receive new data
	bne	func_print_LINE_TX_loop	// if TxFIFO is NOT empty, keep checking until it is empty
	//------------------------------------------------------------------------------
	strb	r3, [r10]			// fill the TxFIFO with '-'
	subs 	r2, r2, #1
	bne 	func_print_LINE_1

	mov		pc, lr				// return to the caller


//FUNCTION: Print from r0 to r9
func_print_r0_r9:
	mov 	r3, #114
	strb	r3, [r10]	//print 'r'
	add		r3, r1, #48
	strb	r3, [r10]	//print the number of register
	mov 	r3, #32
	strb	r3, [r10]	//print space
	mov 	r3, #61
	strb	r3, [r10]	//print '='
	mov 	r3, #48
	strb	r3, [r10]	//print '0'
	mov 	r3, #120
	strb	r3, [r10]	//print 'x'

	mov		pc, lr		// return to the caller


//FUNCTION: Print from r10 to r15
func_print_r10_r15:
	mov 	r3, #114
	strb	r3, [r10]	//print 'r'
	mov 	r3, #49
	strb	r3, [r10]	//print '1'
	add		r3, r1, #48
	strb	r3, [r10]	//print 2nd digit of register number
	mov 	r3, #32
	strb	r3, [r10]	//print space
	mov 	r3, #61
	strb	r3, [r10]	//print '='
	mov 	r3, #48
	strb	r3, [r10]	//print '0'
	mov 	r3, #120
	strb	r3, [r10]	//print 'x'

	mov		pc, lr		// return to the caller


//FUNCTION: Print digits of Register in Hex
func_REG_PRINT:
	mov		r5, #28
	mov		r6, #4
	ldr		r3, [r1]
func_REG_PRINT_1:			//print first 4 digits in Hex
	mov		r4, r3, LSR r5	//set r4 8nd digit in Hex
	sub		r5, r5, #4		//sub r5 to check next digit in Hex
	and		r4, r4, #0xF
	cmp		r4, #10
	addlt	r4, r4, #48		//print num(0-9)
	addge	r4, r4, #87		//print apb(a-f)
	strb	r4, [r10]
	subs	r6, #1
	bne		func_REG_PRINT_1

	mov 	r4, #95
	strb	r4, [r10]		//print '_'
	// ---------  Check to see if the Tx FIFO is empty ------------------------------
func_REG_PRINT_TX_loop:
	ldr r9, [r11]				// read Channel Status Register
	and	r9, r9, #0x8			// read Transmit Buffer Empty bit(bit[3])
	cmp	r9, #0x8				// check if TxFIFO is empty and ready to receive new data
	bne	func_REG_PRINT_TX_loop	// if TxFIFO is NOT empty, keep checking until it is empty
	//------------------------------------------------------------------------------
	mov		r6, #4
	ldr		r3, [r1]
func_REG_PRINT_2:			//Print last 4 digits in Hex
	mov		r4, r3, LSR r5	//Set r4 as 4nd digit in Hex
	sub		r5, r5, #4		//Sub r5 to check next digit in Hex
	and		r4, r4, #0xF
	cmp		r4, #10
	addlt	r4, r4, #48		//Print num(0-9)
	addge	r4, r4, #87		//Print apb(a-f)
	strb	r4, [r10]
	subs	r6, #1
	bne		func_REG_PRINT_2

	mov		pc, lr			// return to the caller


//Check and print info. about NZCV of cpsr
func_print_NZCV:
	mov		r1, r0, LSR#28		//set r1 as NZCV of cpsr

	and		r3, r1, #1<<3
	cmp		r0, #0b1000			//check N of cpsr
	moveq	r3, #78				//if N=1, print N
	movne	r3, #110 			//if N=0, print n
	strb	r3, [r10]

	and		r3, r1, #1<<2
	cmp 	r3, #0b0100			//check Z of cpsr
	moveq	r3, #90				//if Z=1, print Z
	movne	r3, #122			//if Z=0, print z
	strb	r3, [r10]

	and		r3, r1, #1<<1
	cmp 	r3, #0b0010			//check C of cpsr
	moveq	r3, #67				//if Z=1, print C
	movne	r3, #99				//if Z=0, print c
	strb	r3, [r10]

	and		r3, r1, #1
	cmp 	r3, #0b0001			//check V of cpsr
	moveq	r3, #86				//if V=1, print V
	movne	r3, #118			//if V=0, print v
	strb	r3, [r10]

	mov		pc, lr		// return to the caller


//Check and print info. about IF of cpsr
func_print_IF:
	mov		r1, r0, LSR#6		//set r1 as ~IF of cpsr

	and 	r3, r1, #1<<1
	cmp 	r3, #0b0010			//check I of cpsr
	moveq	r3, #73				//if I=1, print I
	movne	r3, #105			//if I=0, print i
	strb	r3, [r10]

	and 	r3, r1, #1
	cmp 	r3, #0b0001			//check F of cpsr
	moveq	r3, #70				//if F=1, print F
	movne	r3, #102			//if F=0, print f
	strb	r3, [r10]

	mov 	r3, #44
	strb	r3, [r10]	//print ','
	mov 	r3, #32
	strb	r3, [r10]	//print space

	mov		pc, lr		// return to the caller


//FUNCTION: Check and print info. about JT of cpsr
func_print_JT:
	mov		r1, r0, LSR#24		//set r1 as ~J of cpsr
	mov		r2, r0, LSR#5		//set r2 as ~T of cpsr
	and		r1, r1, #1
	and		r2, r2, #1
	cmp 	r1, #0b1			//check J of cpsr
	beq		func_print_JT_j1				//if J=1, branch to func_print_JT_j1

	cmp 	r2, #0b1			//if J=0, check T of cpsr
	beq		func_print_JT_j0_t1				//if J=0, T=1, branch to func_print_JT_j0_t1

	mov 	r3, #65				//if J=0, T=0, print 'ARM'
	strb	r3, [r10]	//print 'A'
	mov 	r3, #82
	strb	r3, [r10]	//print 'R'
	mov 	r3, #77
	strb	r3, [r10]	//print 'M'

	mov		pc, lr		// return to the caller

func_print_JT_j0_t1:			//if J=0, T=1, print 'Thumb'
	mov 	r3, #84
	strb	r3, [r10]	//print 'T'
	mov 	r3, #104
	strb	r3, [r10]	//print 'h'
	mov 	r3, #117
	strb	r3, [r10]	//print 'u'
	mov 	r3, #109
	strb	r3, [r10]	//print 'm'
	mov 	r3, #98
	strb	r3, [r10]	//print 'b'

	mov		pc, lr		// return to the caller

func_print_JT_j1:				//if J=1, check T of cpsr
	cmp 	r2, #0b1
	beq		func_print_JT_j1_t1	//if J=1, T=1, branch to func_print_JT_j1_t1

	mov 	r3, #74				//if J=0, T=0, print 'Jazelle'
	strb	r3, [r10]	//print 'J'
	mov 	r3, #97
	strb	r3, [r10]	//print 'a'
	mov 	r3, #122
	strb	r3, [r10]	//print 'z'
	mov 	r3, #101
	strb	r3, [r10]	//print 'e'
	mov 	r3, #108
	strb	r3, [r10]	//print 'l'
	mov 	r3, #108
	strb	r3, [r10]	//print 'l'
	mov 	r3, #101
	strb	r3, [r10]	//print 'e'

	mov		pc, lr		// return to the caller

func_print_JT_j1_t1:			//if J=1, T=1, print 'ThumbEE'
	mov 	r3, #84
	strb	r3, [r10]	//print 'T'
	mov 	r3, #104
	strb	r3, [r10]	//print 'h'
	mov 	r3, #117
	strb	r3, [r10]	//print 'u'
	mov 	r3, #109
	strb	r3, [r10]	//print 'm'
	mov 	r3, #98
	strb	r3, [r10]	//print 'b'
	mov 	r3, #69
	strb	r3, [r10]	//print 'E'
	mov 	r3, #69
	strb	r3, [r10]	//print 'E'

	mov		pc, lr		// return to the caller


//FUNCTION: Check and print info. about Current mode of cpsr
func_print_MODE:
	mov 	r3, #99
	strb	r3, [r10]	//print 'c'
	mov 	r3, #117
	strb	r3, [r10]	//print 'u'
	mov 	r3, #114
	strb	r3, [r10]	//print 'r'
	mov 	r3, #114
	strb	r3, [r10]	//print 'r'
	mov 	r3, #101
	strb	r3, [r10]	//print 'e'
	mov 	r3, #110
	strb	r3, [r10]	//print 'n'
	mov 	r3, #116
	strb	r3, [r10]	//print 't'
	mov 	r3, #32
	strb	r3, [r10]	//print space
	mov 	r3, #109
	strb	r3, [r10]	//print 'm'
	mov 	r3, #111
	strb	r3, [r10]	//print 'o'
	mov 	r3, #100
	strb	r3, [r10]	//print 'd'
	mov 	r3, #101
	strb	r3, [r10]	//print 'e'
	mov 	r3, #32
	strb	r3, [r10]	//print space
	mov 	r3, #61
	strb	r3, [r10]	//print '='

	and		r3, r0, #1<<3
	and		r4, r0, #1<<2
	and		r5, r0, #1<<1
	and		r6, r0, #1

	cmp		r3, #0b1000			//check bit#3 of cpsr
	beq		bit_1010			//if bit#3=1, branch to bit_1010

	cmp 	r4, #0b0100			//check bit#2 of cpsr
	beq		bit_0110			//if bit#2=1, branch to bit_0110

	cmp 	r5, #0b0010			//check bit#1 of cpsr
	beq		bit_0010			//if bit#1=1, branch to bit_0010

	cmp 	r6, #0b0001			//check bit#0 of cpsr
	beq		bit_0001			//if bit#0=1, branch to bit_0001

	mov 	r3, #85			//if bit_0000, print USR
	strb	r3, [r10]	//print 'U'
	mov 	r3, #83
	strb	r3, [r10]	//print 'S'
	mov 	r3, #82
	strb	r3, [r10]	//print 'R'

	mov		pc, lr		// return to the caller

bit_0001: //FIQ
	mov 	r3, #70			//if bit_0001, print FIQ
	strb	r3, [r10]	//print 'F'
	mov 	r3, #73
	strb	r3, [r10]	//print 'I'
	mov 	r3, #81
	strb	r3, [r10]	//print 'Q'

	mov		pc, lr		// return to the caller

bit_0010: //IRQ
	cmp 	r6, #0b0001			//check bit#0 of cpsr
	beq		bit_0011			//if bit#0=1, branch to bit_0010

	mov 	r3, #73			//if bit_0010, print IRQ
	strb	r3, [r10]	//print 'I'
	mov 	r3, #82
	strb	r3, [r10]	//print 'R'
	mov 	r3, #81
	strb	r3, [r10]	//print 'Q'

	mov		pc, lr		// return to the caller

bit_0011: //SVC

	mov 	r3, #83			//if bit_0011, print SVC
	strb	r3, [r10]	//print 'S'
	mov 	r3, #86
	strb	r3, [r10]	//print 'V'
	mov 	r3, #67
	strb	r3, [r10]	//print 'C'

	mov		pc, lr		// return to the caller

bit_0110: //MON
	cmp 	r6, #0b0001			//check bit#0 of cpsr
	beq		bit_0111			//if bit#0=1, branch to bit_0111

	mov 	r3, #77			//if bit_0110, print MON
	strb	r3, [r10]	//print 'M'
	mov 	r3, #79
	strb	r3, [r10]	//print 'O'
	mov 	r3, #78
	strb	r3, [r10]	//print 'N'

	mov		pc, lr		// return to the caller

bit_0111: //ABT
	mov 	r3, #65			//if bit_0111, print ABT
	strb	r3, [r10]	//print 'A'
	mov 	r3, #66
	strb	r3, [r10]	//print 'B'
	mov 	r3, #84
	strb	r3, [r10]	//print 'T'

	mov		pc, lr		// return to the caller

bit_1010: //HYP
	cmp 	r4, #0b0100			//check bit#2 of cpsr
	beq		bit_1111			//if bit#2=1, branch to bit_1111

	cmp 	r6, #0b0001			//check bit#0 of cpsr
	beq		bit_1011			//if bit#0=1, branch to bit_1011

	mov 	r3, #72			//if bit_1010, print HYP
	strb	r3, [r10]	//print 'H'
	mov 	r3, #89
	strb	r3, [r10]	//print 'Y'
	mov 	r3, #80
	strb	r3, [r10]	//print 'P'

	mov		pc, lr		// return to the caller

bit_1011: //UND
	mov 	r3, #85			//if bit_1011, print UND
	strb	r3, [r10]	//print 'U'
	mov 	r3, #78
	strb	r3, [r10]	//print 'N'
	mov 	r3, #68
	strb	r3, [r10]	//print 'D'

	mov		pc, lr		// return to the caller

bit_1111: //SYS
	mov 	r3, #83			//if bit_1111, print SYS
	strb	r3, [r10]	//print 'S'
	mov 	r3, #89
	strb	r3, [r10]	//print 'Y'
	mov 	r3, #83
	strb	r3, [r10]	//print 'S'

	mov		pc, lr		// return to the caller


end:

.endm
