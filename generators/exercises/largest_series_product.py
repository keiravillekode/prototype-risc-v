FUNC_PROTO = """\
#include "vendor/unity.h"

#include <stdint.h>

#define INVALID_CHARACTER -1
#define NEGATIVE_SPAN -2
#define INSUFFICIENT_DIGITS -3

extern int32_t largest_product(int span, const char *digits);
"""

def gen_func_body(prop, inp, expected):
    span = inp["span"]
    digits = inp["digits"]
    if isinstance(expected, dict):
        expectations = {}
        expectations["digits input must only contain digits"] = "INVALID_CHARACTER"
        expectations["span must not be negative"] = "NEGATIVE_SPAN"
        expectations["span must not exceed string length"] = "INSUFFICIENT_DIGITS"
        expected = expectations[expected["error"]]

    return (
        f'TEST_ASSERT_EQUAL_INT32({expected}, largest_product({span}, "{digits}"));\n'
    )
