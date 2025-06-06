FUNC_PROTO = """\
#include "vendor/unity.h"

#include <stdint.h>

typedef enum {
    INVALID = 0,
    DEFICIENT,
    PERFECT,
    ABUNDANT,
} category_t;

extern category_t classify(int number);
"""


def gen_func_body(prop, inp, expected):
    number = inp["number"]
    if isinstance(expected, dict):
        expected = "INVALID"
    expected = expected.upper()
    return f"TEST_ASSERT_EQUAL_INT({expected}, {prop}({number}));\n"
