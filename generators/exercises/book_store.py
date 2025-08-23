FUNC_PROTO = """\
#include "vendor/unity.h"

#include <stddef.h>
#include <stdint.h>

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

extern void total(size_t basket_count, const uint16_t *basket, uint16_t *tally);

/* extern uint32_t total_true(size_t basket_count, const uint16_t *basket); */
"""


def array_literal(numbers):
    return str(numbers).replace("[", "{").replace("]", "}")


def gen_func_body(prop, inp, expected):
    basket = inp["basket"]
    str_list = []
    str_list.append("uint16_t tally[6] = { 0, 0, 0, 0, 0, 0 };\n")
    if len(basket) > 0:
        str_list.append(f"const uint16_t basket[] = {array_literal(basket)};\n")
        str_list.append(f"total(ARRAY_SIZE(basket), basket, tally);\n")
    else:
        str_list.append(f"total(0, NULL, tally);\n")

    expected = [0] * 6
    for book in basket:
        expected[book] += 1

    previous = expected[5]
    for i in range(4, 0, -1):
        current = expected[i]
        expected[i] -= previous
        previous = current

    str_list.append(f"const uint16_t expected[6] = {array_literal(expected)};\n")
    str_list.append(f'TEST_ASSERT_EQUAL_INT16_ARRAY(expected, tally, 6);\n')

    return "".join(str_list)

def gen_func_body_true(prop, inp, expected):
    basket = inp["basket"]
    str_list = []
    if len(basket) > 0:
        str_list.append(f"const uint16_t basket[] = {array_literal(basket)};\n")
        str_list.append(
            f"TEST_ASSERT_EQUAL_UINT32({expected}, {prop}(ARRAY_SIZE(basket), basket));\n"
        )
    else:
        str_list.append(f"TEST_ASSERT_EQUAL_UINT32({expected}, {prop}(0, NULL));\n")
    return "".join(str_list)
