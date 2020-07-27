.macro DEBUG_macro
	PUSH {r0-r12,r14}	//Push r0-r12,r14 (r13 is restored when pop all)
	sub	r0, pc, #0xc	//r0=PC-0x00c (3 Inst before)
	PUSH {r0}			//Push r15 (push value of PC before executing DEBUG_macro)
	mrs r0, cpsr		//Get value of cpsr register
	PUSH {r0}			//Push value of cpsr

	mov	r12, sp		//use r12 as stack_base

	PUSH {PC}		//use PC to move back to DEBUG_macro after printing info.
	b	debug_macro_start

	POP {r0}
	msr cpsr, r0
	POP {r0}
	POP {r0-r12, r14}	//Pop and restore registers
.endm
