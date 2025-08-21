#include "vendor/unity.h"

extern int color_code(const char *color);

void setUp(void) {
}

void tearDown(void) {
}

void test_black(void) {
    TEST_ASSERT_EQUAL_INT(0, color_code("black"));
}

void test_white(void) {
    TEST_IGNORE();
    TEST_ASSERT_EQUAL_INT(9, color_code("white"));
}

void test_orange(void) {
    TEST_IGNORE();
    TEST_ASSERT_EQUAL_INT(3, color_code("orange"));
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_black);
    RUN_TEST(test_white);
    RUN_TEST(test_orange);
    return UNITY_END();
}
