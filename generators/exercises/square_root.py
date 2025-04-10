FUNC_PROTO = """\
#include "vendor/unity.h"

#include <stddef.h>

extern size_t square_root(size_t radicand);
"""

def gen_func_body(prop, inp, expected):
    radicand = inp["radicand"]
    return f"TEST_ASSERT_EQUAL_UINT({expected}, square_root({radicand}));\n"
