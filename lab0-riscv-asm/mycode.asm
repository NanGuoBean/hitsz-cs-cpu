initialize:			# Initialize them
	addi s1,s1,3
	lui  s1,0xFFFFF  # pip loc 
	andi s2,s2,0
	andi s3,s3,0
    addi s2,s1,0x70  # switch loc
    addi s3,s1,0x60  # led loc
judgeopt:			#split switch to number, then jump to the option by opt number
	
	lw	 s0,0x00(s2)	 # read switch
	andi s4,s0,0xFF		 # get first num
	srli   s0,s0,8
	andi s5,s0,0xFF	# get second num
	srli   s0,s0,13
	andi s6,s0,0xFF	# get opt num
	
	andi s0,s0,0

	addi s0,s0,1		# A+B
	beq  s6,s0,optadd
	
	addi s0,s0,1		# A-B
	beq  s6,s0,optsub

	addi s0,s0,1		# A&B
	beq  s6,s0,optand

	addi s0,s0,1		# A|B
	beq  s6,s0,optor

	addi s0,s0,1		# A<<B
	beq  s6,s0,optlm

	addi s0,s0,1		# A>>B
	beq  s6,s0,optrm

	addi s0,s0,1		# A*B
	beq  s6,s0,optmul

	andi s0,s0,0		# nothing match,continue to judge
	jal showled		
showled:				# show answer
	sw	 s0,0x00(s3)
	sw	 s0,0x00(s1)
	jal  judgeopt
optadd:
	add	 s0,s4,s5
	jal	 showled
optsub:
	sub	 s0,s4,s5
	jal	 showled
optand:
	and	 s0,s4,s5
	jal	 showled
optor:
	or	 s0,s4,s5
	jal	 showled
optlm:
	sll	 s0,s4,s5
	jal	 showled
optrm:
	srl	 s0,s4,s5
	jal	 showled
	
optmul:
	andi s0,s0,0
	andi s7,s7,0
	andi s8,s8,1
mulcase0:
	beq  s4,s7, showled # equal 0 means ok
	andi s9, s4, 1		# lastnumber
	srli	 s4, s4, 1		# A/2
	beq	 s9,s7, mulcase1 # equal to 0, skip add
	add  s0,s5,s0
mulcase1:
	slli	 s5,s5,1		# B*2
	jal mulcase0	
