import re

FUNC_PROTO = """\
#include "vendor/unity.h"

extern long square_of_sum(long number);
extern long sum_of_squares(long number);
extern long difference_of_squares(long number);
"""

def to_snake_case(camel_case):
    return re.sub('([A-Z]+)', r'_\1', camel_case).lower()

def gen_func_body(prop, inp, expected):
    number = inp["number"]
    prop = to_snake_case(prop)
    return f"TEST_ASSERT_EQUAL_INT({expected}, {prop}({number}));\n"
