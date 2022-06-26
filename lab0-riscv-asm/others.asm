lui   s1,0xFFFFF # s1 存储基址

 addi s2, x0, 0x80 # s2用于检验是否为负数
 addi s8, x0, -256 # 用于符号位扩展
 
 addi s10 ,x0, 1
 addi s11, x0, 2
 
 
switled:                          # Test led and switch
 lw   s0,0x70(s1)          # read switch
 andi a1, s0, 0x0FF # a1中存储第一个输入数
 srli s0, s0, 8
 andi a2, s0, 0x0FF # a2中存储第二个输入数
 srli s0, s0, 13
 andi a3, s0, 0x1F # a3 中存储我们的操作符
 
 blt a1, s2, L1
 or a1, a1, s8
L1: # 在上一行对应输入数a1的符号位扩展，跳转表示不用拓展 
 blt a2, s2 ,L2
 or a2, a2, s8 
L2: # 在上一行对应输入数a2的符号位扩展，跳转表示不用拓展
 addi s3, x0, 1
 beq a3, s3, addoperation
 addi s3, s3, 1
 beq a3, s3, suboperation
 addi s3, s3, 1
 beq a3, s3, andoperation
 addi s3, s3, 1
 beq a3, s3, oroperation
 addi s3, s3, 1
 beq a3, s3, leftoperation
 addi s3, s3, 1
 beq a3, s3, rightoperation
 addi s3, s3, 1
 beq a3, s3, multioperation
 
L3:
 sw a5,0x00(s1)
 j switled


addoperation:
 add a5, a1, a2
 j L3

suboperation:
 sub a5, a1, a2
 j L3

andoperation:
 and a5, a1, a2
 j L3

oroperation:
 or a5, a1, a2
 j L3
 
leftoperation:
 sll a5, a1, a2
 j L3

rightoperation:
 sra a5, a1, a2
 j L3
 
multioperation:
 # 使用Booth乘法实现 补码乘法
 addi t0, x0, 8 #  booth乘法次数上限
 addi t1, x0, 0 # i 计数器
 
 addi a5, a5, 0
 slli a1, a1, 8
 slli a2, a2, 1 # 左移一位，相当于在最后补0，符合booth乘法要求
 for:
  addi t1, t1, 1
  bge t1, t0, forend
  andi t2, a2, 0x3 # 获取最低两位，用以判断
  
  bne t2 , s10, else1  # 最低两位不是01不进入if
  add a5, a5, a1
  else1:
  bne t2, s11, else2
  sub a5, a5, a1
  else2:
  srai a5, a5, 1
  srai a2, a2, 1
  jal x0, for
 forend:
 srai a5, a5, 1
 j L3
