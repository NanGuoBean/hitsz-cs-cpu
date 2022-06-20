	addi s1,s1,3
	lui  s1,0xFFFFF  #pip loc 
	andi s2,s2,0
	andi s3,s3,0
    addi s2,s1,0x70  #switch loc
    addi s3,s1,0x60  #led loc
switled:                      # Test led and switch
	lw   s0,0x00(s2)          # read switch
	sw   s0,0x00(s3)          # write led	
    sw   s0,0x00(s1)
	jal switled
