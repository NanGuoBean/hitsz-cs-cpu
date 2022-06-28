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
	
 	addi s0,x0,0x80
  	blt s4, s0, L1
	# change to ~x +1 and 16bits
 	ori s4, s4, -256
	xori s4,s4,0x7F
	addi s4,s4,1
L1: 
    blt s5, s0 ,L2
	# change to ~x +1 and 16bits
    ori s5, s5, -256
	xori s5,s5,0x7F
	addi s5,s5,1
L2:
	addi s0,x0,0

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
	
optmul: # booth algorithm
 addi s7, x0, 8 

 addi s9 ,x0, 1		# 01
 addi s10 ,x0, 2	# 10

 addi s0, x0, 0
 slli s4, s4, 8
 slli s5, s5, 1 # add 0
 for:
  addi s7, s7, -1
  beq s7, x0, forend
  andi s8, s5, 3 
  bne s9 , s8, else1  
  add s0, s0, s4
  else1:
  bne s8, s10, else2
  sub s0, s0, s4
  else2:
  srai s0, s0, 1
  srai s5, s5, 1
  jal for
 forend:
 srai s0, s0, 1
 jal showled