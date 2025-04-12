FUNC_PROTO = """\
#include "vendor/unity.h"

extern int equilateral(long a, long b, long c);
extern int isosceles(long a, long b, long c);
extern int scalene(long a, long b, long c);
"""

def describe(case):
    description = case["description"]
    property = case["property"]
    return f"{property} {description}"

def gen_func_body(prop, inp, expected):
    a = inp["sides"][0]
    b = inp["sides"][1]
    c = inp["sides"][2]
    if expected:
        macro = "TEST_ASSERT_TRUE"
    else:
        macro = "TEST_ASSERT_FALSE"
    return f"{macro}({prop}({a}, {b}, {c}));\n"
