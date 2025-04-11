FUNC_PROTO = """\
#include "vendor/unity.h"

#include <stddef.h>

extern int egg_count(size_t number);
"""

def gen_func_body(prop, inp, expected):
    number = inp["number"]
    return f"TEST_ASSERT_EQUAL_INT({expected}, egg_count({number}));\n"
