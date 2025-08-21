FUNC_PROTO = """\
#include "vendor/unity.h"

extern int color_code(const char *color);
"""


def gen_func_body(prop, inp, expected):
    str_list = []
    color = inp["color"]
    return f'TEST_ASSERT_EQUAL_INT({expected}, {prop}("{color}"));\n'
