.text
main:
lui $s0,0x3224
ori $s0, $s0, 0x5689
mtc1 $s0, $f0
cvt.s.w $f0, $f0
cvt.w.s $f0, $f0
mfc1 $s1, $f0
.data
