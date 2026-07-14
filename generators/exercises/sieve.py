FUNC_PROTO = """\
#include "vendor/unity.h"

#include <stddef.h>
#include <stdint.h>

#define MAX_ARRAY_SIZE 200
#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

extern size_t sieve(uint32_t *primes, uint32_t limit);
"""


def array_literal(numbers):
    return str(numbers).replace("[", "{").replace("]", "}")


def gen_func_body(prop, inp, expected):
    limit = inp["limit"]
    str_list = []
    if len(expected) > 0:
        str_list.append(f"const uint32_t expected[] = {array_literal(expected)};\n")
    str_list.append("uint32_t actual[MAX_ARRAY_SIZE];\n")
    str_list.append(f"const size_t size = sieve(actual, {limit});\n")
    if len(expected) > 0:
        str_list.append("TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);\n")
        str_list.append("TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);\n")
    else:
        str_list.append("TEST_ASSERT_EQUAL_UINT(0U, size);\n")
    return "".join(str_list)
