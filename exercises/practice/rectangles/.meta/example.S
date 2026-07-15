.text
.globl rectangles

/* extern int rectangles(const char **strings); */
rectangles:
		addi 	sp, sp, -16
		sw 		s0, 0(sp)
		sw 		s1, 4(sp)
		sw 		s2, 8(sp)
		sw 		s3, 12(sp)

		move 	t0, a0 					/* pointer into strings */
		move 	a0, zero 				/* count */
		li 		a5, '+'
		li 		a6, '-'
		li 		a7, '|'

.top_row:
		lw 		t1, 0(t0) 				/* start of top row */
		addi 	t0, t0, 4
		beqz 	t1, .return

		addi 	t2, t1, -1

.left_column:
		addi 	t2, t2, 1 				/* left column, pointer into top row */
		lb 		t6, 0(t2)
		beqz 	t6, .top_row

		bne 	t6, a5, .left_column

		move 	t3, t2

.right_column:
		addi 	t3, t3, 1 				/* right column, pointer into top row */
		lb 		t6, 0(t3)
		beqz 	t6, .left_column

		beq 	t6, a6, .right_column

		bne 	t6, a5, .left_column

		sub 	a2, t2, t1 				/* left column index */
		sub 	a3, t3, t1 				/* right column index */
		move 	t4, t0

.bottom_row:
		lw 		t5, 0(t4) 				/* start of bottom row */
		addi 	t4, t4, 4
		beqz 	t5, .right_column

		add 	s2, t5, a2
		add 	s3, t5, a3
		lb 		s0, 0(s2)
		lb 		s1, 0(s3)

		beq 	s0, a5, .valid_bottom_left

		bne  	s0, a7, .right_column

.valid_bottom_left:
		beq 	s1, a5, .valid_bottom_right

		bne  	s1, a7, .right_column

.valid_bottom_right:
		bne 	s0, a5, .bottom_row

		bne 	s1, a5, .bottom_row

		j 		.scan_bottom

.read_bottom:
		lb 		s0, 0(s2)
		beq 	s0, a5, .scan_bottom

		bne 	s0, a6, .bottom_row

.scan_bottom:
		addi 	s2, s2, 1
		bne 	s2, s3, .read_bottom

		addi 	a0, a0, 1
		j 		.bottom_row

.return:
		lw 		s3, 12(sp)
		lw 		s2, 8(sp)
		lw 		s1, 4(sp)
		lw 		s0, 0(sp)
		addi 	sp, sp, 16
		ret
