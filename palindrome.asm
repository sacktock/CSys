.data
ourinput:
.space 160
palindrome:
.asciiz "string is a palindrome"
notpalindrome:
.asciiz "string is not a palindrome"
.text
main:
li 	$v0, 8
la 	$a0, ourinput
li 	$a1, 160
syscall

la	$t1, ourinput
move	$t2, $t1

loop:
lb	$t3, ($t2)
beqz	$t3, exitloop
addi	$t2, $t2, 1
b	loop
exitloop:
subu	$t2, $t2, 2

checkloop:
beq	$t1, $t2, true
lb	$t3, ($t1)
lb	$t4, ($t2)
bne	$t3, $t4, false
addi	$t1, $t1, 1
beq	$t1, $t2, true
subu	$t2, $t2, 1
b	checkloop

true:
li	$v0, 4
la	$a0, palindrome
syscall
b	done

false:
li	$v0, 4
la	$a0, notpalindrome
syscall

done:
