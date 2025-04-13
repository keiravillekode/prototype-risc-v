FUNC_PROTO = """\
#include "vendor/unity.h"

#include <stddef.h>
#include <stdint.h>

#define MAX_ARRAY_SIZE 100
#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

extern size_t factors(uint32_t* dest, uint32_t value);
"""

def array_literal(numbers):
    return str(numbers).replace('[', '{').replace(']', '}')

def gen_func_body(prop, inp, expected):
    value = inp["value"]
    str_list = []
    if len(expected) > 0:
        str_list.append(f'const uint32_t expected[] = {array_literal(expected)};\n')
    str_list.append(f'uint32_t actual[MAX_ARRAY_SIZE];\n')
    str_list.append(f'const size_t size = factors(actual, {value});\n')
    if len(expected) > 0:
        str_list.append(f'TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);\n')
        str_list.append(f'TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);\n')
    else:
        str_list.append(f'TEST_ASSERT_EQUAL_UINT(0U, size);\n')
    return "".join(str_list)
