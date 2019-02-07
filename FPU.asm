.text
main:
addi $s0, $0, -2
addi $s1, $0, -8
mtc1 $s0, $f0
mtc1 $s1, $f1
cvt.s.w $f0, $f0
cvt.s.w $f1, $f1
div.s $f2,$f0,$f1
.data
