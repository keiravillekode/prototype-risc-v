.text
.globl row
.globl column


/* extern size_t column(int32_t *buffer, const char *input, size_t index) */
column:
        move 	a3, a2
        move 	a2, zero 		/* accept any row */
        j 	process


/* extern size_t row(int32_t *buffer, const char *input, size_t index) */
row:
        move 	a3, zero 		/* accept any column */


/* size_t process(int32_t *buffer, const char *input, size_t row, size_t column) */
process:
	move 	a4, a0 			/* start of output buffer */
	li 	a5, 10
	li 	a6, '-'
	li  	a7, '0'
	li 	t5, '\n'
	li 	t6, ' '
	move	t0, zero

.newline:
	addi	t0, t0, 1 		/* current row */
	li 	t1, 1 			/* current column */

.filter:
	beq 	t0, a2, .accept

	beq 	t1, a3, .accept

.skip:
	lbu 	t2, 0(a1)
	addi 	a1, a1, 1
	bgt 	t2, t6, .skip 		/* consume until we reach whitespace */

.advance:
	beqz 	t2, .return 		/* end of string */

	beq 	t2, t5, .newline

	addi 	t1, t1, 1 		/* current column */
	j 	.filter

.return:
	sub 	a0, a0, a4
	srl 	a0, a0, 2 		/* divide by 4 */
	ret

.accept:
	move 	t4, zero 		/* not negative */
	move 	t3, zero
	lbu 	t2, 0(a1)
	addi 	a1, a1, 1
	bne 	t2, a6, .accept_digit

	li 	t4, 1 			/* negative */
	lbu 	t2, 0(a1)
	addi 	a1, a1, 1

.accept_digit:
	sub 	t2, t2, a7 		/* 0..9 */
	mul 	t3, a5, t3
	add 	t3, t3, t2
	lbu 	t2, 0(a1)
	addi 	a1, a1, 1
	bgt 	t2, t6, .accept_digit

	beqz 	t4, .write
	neg 	t3, t3

.write:
	sw 	t3, 0(a0)
	addi 	a0, a0, 4
	j 	.advance
