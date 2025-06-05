#include "vendor/unity.h"

#include <stddef.h>
#include <stdint.h>

#define MAX_ARRAY_SIZE 800
#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

extern size_t rows(uint32_t *dest, size_t count);

void setUp(void) {
}

void tearDown(void) {
}

void test_zero_rows(void) {
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = rows(actual, 0);
    TEST_ASSERT_EQUAL_UINT(0U, size);
}

void test_single_row(void) {
    TEST_IGNORE();
    const uint32_t expected[] = {
        // clang-format off
        1,
        // clang-format on
    };
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = rows(actual, 1);
    TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);
}

void test_two_rows(void) {
    TEST_IGNORE();
    const uint32_t expected[] = {
        // clang-format off
        1,
        1, 1,
        // clang-format on
    };
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = rows(actual, 2);
    TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);
}

void test_three_rows(void) {
    TEST_IGNORE();
    const uint32_t expected[] = {
        // clang-format off
        1,
        1, 1,
        1, 2, 1,
        // clang-format on
    };
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = rows(actual, 3);
    TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);
}

void test_four_rows(void) {
    TEST_IGNORE();
    const uint32_t expected[] = {
        // clang-format off
        1,
        1, 1,
        1, 2, 1,
        1, 3, 3, 1,
        // clang-format on
    };
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = rows(actual, 4);
    TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);
}

void test_five_rows(void) {
    TEST_IGNORE();
    const uint32_t expected[] = {
        // clang-format off
        1,
        1, 1,
        1, 2, 1,
        1, 3, 3, 1,
        1, 4, 6, 4, 1,
        // clang-format on
    };
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = rows(actual, 5);
    TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);
}

void test_six_rows(void) {
    TEST_IGNORE();
    const uint32_t expected[] = {
        // clang-format off
        1,
        1, 1,
        1, 2, 1,
        1, 3, 3, 1,
        1, 4, 6, 4, 1,
        1, 5, 10, 10, 5, 1,
        // clang-format on
    };
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = rows(actual, 6);
    TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);
}

void test_ten_rows(void) {
    TEST_IGNORE();
    const uint32_t expected[] = {
        // clang-format off
        1,
        1, 1,
        1, 2, 1,
        1, 3, 3, 1,
        1, 4, 6, 4, 1,
        1, 5, 10, 10, 5, 1,
        1, 6, 15, 20, 15, 6, 1,
        1, 7, 21, 35, 35, 21, 7, 1,
        1, 8, 28, 56, 70, 56, 28, 8, 1,
        1, 9, 36, 84, 126, 126, 84, 36, 9, 1,
        // clang-format on
    };
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = rows(actual, 10);
    TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_zero_rows);
    RUN_TEST(test_single_row);
    RUN_TEST(test_two_rows);
    RUN_TEST(test_three_rows);
    RUN_TEST(test_four_rows);
    RUN_TEST(test_five_rows);
    RUN_TEST(test_six_rows);
    RUN_TEST(test_ten_rows);
    return UNITY_END();
}
