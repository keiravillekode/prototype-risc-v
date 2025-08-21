FUNC_PROTO = """\
#include "vendor/unity.h"

#include <stddef.h>

extern int value(const char *first, const char *second, const char *third, const char *fourth);
"""


def gen_func_body(prop, inp, expected):
    colors = inp["colors"]
    while len(colors) < 4:
        colors = colors + [None]

    def serialize(color):
        if color is None:
            return 'NULL'
        return f'"{color}"'

    colors = ', '.join(map(serialize, colors))
    return f"TEST_ASSERT_EQUAL_INT({expected}, {prop}({colors}));\n"
