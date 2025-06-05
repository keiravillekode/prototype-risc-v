.section .rodata
vowels:
        /* non-zero for 'a' 'e' 'i' 'o' 'u' 'y' */
        .byte 1,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0

.text
.globl translate

/* 
| Register | Usage        | Type    | Description                             |
| -------- | ------------ | ------- | --------------------------------------- |
| `a0`     | input/output | address | output pointer                          |
| `a1`     | input        | address | beginning of word(s)                    |
| `a2`     | temporary    | address | vowels table, minus 'a'                 |
| `a3`     | temporary    | byte    | 'a'                                     |
| `a4`     | temporary    | byte    | 'u'                                     |
| `a5`     | temporary    | byte    | 'x'                                     |
| `a6`     | temporary    | byte    | 'y'                                     |
| `a7`     | temporary    | byte    | 'r' or 't' or 'q'                       |
| `t0`     | temporary    | address | position in current word                |
| `t1`     | temporary    | address | end of current word                     |
| `t3`     | temporary    | byte    | previous letter in word                 |
| `t4`     | temporary    | byte    | current letter in word                  |
| `t5`     | temporary    | byte    | second letter in word                   |
| `t6`     | temporary    | byte    | non-zero when current letter is a vowel |
*/

/* extern void translate(char *buffer, const char *phrase); */
translate:
        la      a2, vowels  
        li      a3, 'a'
        li      a4, 'u'
        li      a5, 'x'
        li      a6, 'y'
        sub     a2, a2, a3              /* vowels table, minus 'a' */

start_word:
        move    t0, a1                  /* beginning of word */
        lb      t4, 0(a1)               /* first letter in word */
        beqz    t4, return

        lb      t5, 1(a1)               /* second letter in word */
        add     t6, a2, t4
        lb      t6, 0(t6)               /* non-zero if first letter is a vowel or 'y' */
        bnez    t6, check_yt

check_xr:
        bne     t4, a5, consonant
        li      a7, 'r'
        bne     t5, a7, consonant         
        j       vowel                   /* Treat initial 'x' 'r' as vowel */

check_yt:
        bne     t4, a6, vowel
        li      a7, 't'
        beq     t5, a7, vowel           /* Treat initial 'y' 't' as vowel */

consonant:
        addi    t0, t0, 1
        move    t3, t4                  /* previous letter */
        lb      t4, 0(t0)               /* current letter in word */
        blt     t4, a3, vowel           /* jump forward as we have reached the end of the word */

        add     t6, a2, t4
        lb      t6, 0(t6)               /* non-zero if current letter is a vowel or 'y' */
        beqz    t6, consonant

        bne     t4, a4, vowel
        li      a7, 'q'
        bne     t3, a7, vowel
        addi    t0, t0, 1               /* group 'u' after 'q' with leading consonants */

vowel:
                                        /* Letters a1 (inclusive) through t0 (exclusive) */
                                        /* will be output after the word's remaining letters. */
        move    t1, t0
        j       check_for_remaining_letters


copy_remaining_letters:
        addi    t1, t1, 1
        sb      t4, 0(a0)
        addi    a0, a0, 1               /* Increment output pointer */

check_for_remaining_letters:
        lb      t4, 0(t1)
        bge     t4, a3, copy_remaining_letters
        j       check_for_leading_consonants


copy_leading_consonants:
        lb      t5, 0(a1)
        addi    a1, a1, 1
        sb      t5, 0(a0)
        addi    a0, a0, 1               /* Increment output pointer */

check_for_leading_consonants:
        bne     a1, t0, copy_leading_consonants

copy_ay:
        sb      a3, 0(a0)               /* 'a' */
        addi    a0, a0, 1               /* Increment output pointer */
        sb      a6, 0(a0)               /* 'y' */
        addi    a0, a0, 1               /* Increment output pointer */
        beqz    t4, return              /* Check for null terminator */

        sb      t4, 0(a0)               /* Output space between words */
        addi    a0, a0, 1               /* Increment output pointer */
        addi    a1, t1, 1               /* Start of next word */
        j       start_word

return:
        sb      zero, 0(a0)
        ret
