# Very simple interrupt driven I/O
	.text
main:				# user program
	ori	$t1, $0,0			
	la	$t7, enable_rxint
   	jalr $t7		# GO TO ENABLE_RXINT
   	
loop:	
	addi	$t1, $t1, 1	#pointless loop that could be doing something
	beq	$0,$0, loop
exit:
	li      $v0, 10		
	syscall			

	.ktext 0x80000180	# Forces interrupt routine below to be
				# located at address 0x80000180.
interp:
	# interrupt handler - all registers are precious
	addiu	$sp,$sp,-32	# Save registers. 
	.set noat		# Tell assembler to stop using $at...
	sw	$at,28($sp)	# so we can use it.
	.set at			# Now give back $at to the assembler.
	# Save registers.  Remember, this is an interrupt routine
	# so it has to save anything it touches, including $t registers.
	sw	$ra,24($sp)
	sw	$a0,20($sp)
	sw	$v0,16($sp)
	sw	$t3,12($sp)
	sw	$t2,8($sp)
	sw	$t1,4($sp)
	sw	$t0,0($sp)	

	lui     $t0,0xffff		# get address of control regs
	lw	$t1,0($t0)	        # read rcv ctrl
	andi	$t1,$t1,0x0001		# extract ready bit
	beq	$t1,$0,intDone		#
	lw	$a0,4($t0)		# read key
	lw	$t1,8($t0)		# read tx ctrl
	andi	$t1,$t1,0x0001  	# extract ready bit 
	beq	$t1,$0,intDone		# still busy discard
	sw	$a0, 0xc($t0)		# write key
	
intDone:
	## Clear Cause register
	mfc0	$t0,$13		# get Cause register, then clear it
	mtc0	$0, $13

	## restore registers
	lw	$t0,0($sp)
	lw	$t1,4($sp) 
	lw	$t2,8($sp) 
	lw	$t3,12($sp) 
	lw	$v0,16($sp) 
	lw	$a0,20($sp)
	lw	$ra,24($sp)
	.set noat 
	lw $at,28($sp) 
	.set at 
	addiu	$sp,$sp,32
	eret			# rtn from int and reenable ints
				# Sets PC to current EPC and status to original status

enable_rxint:	
	mfc0	$t0, $12	# record interrupt state
	andi	$t0, $t0, 0xFFFE	# clear int enable flag
	mtc0    $t0, $12	# Turn interrupts off.	
	lui     $t0,0xffff		
	lw	$t1,0($t0)	        # read rcv ctrl
	ori	$t1,$t1,0x0002		# set the input interupt enable
	sw	$t1,0($t0)	        # update rcv ctrl
	mfc0	$t0, $12	# record interrupt state
	ori	$t0, $t0, 0x0001# set int enable flag
	mtc0    $t0, $12	# Turn interrupts on
	jr	$ra

	.data
