#include "vendor/unity.h"

#include <stdint.h>

#define BUFFER_SIZE 20
#define ARRAY_SIZE(x) sizeof(x) / sizeof(x[0])

#define EMPTY_RESULT 0
#define INVALID_INPUT -1

typedef struct {
    uint32_t count;
    uint32_t factors[BUFFER_SIZE][2];
} factor_t;

extern int32_t largest(factor_t *factors, uint32_t min, uint32_t max);
extern int32_t smallest(factor_t *factors, uint32_t min, uint32_t max);

void setUp(void) {
}

void tearDown(void) {
}

void test_find_the_smallest_palindrome_from_single_digit_factors(void) {

    factor_t factors = {0};
    const int32_t result = smallest(&factors, 1, 9);
    const uint32_t expected[][2] = {{1, 1}};

    TEST_ASSERT_EQUAL_INT32(1, result);
    TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), factors.count);

    for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
        TEST_ASSERT_EQUAL_UINT32_ARRAY(expected[i], factors.factors[i], 2);
    }
}

void test_find_the_largest_palindrome_from_single_digit_factors(void) {
    TEST_IGNORE();

    factor_t factors = {0};
    const int32_t result = largest(&factors, 1, 9);
    const uint32_t expected[][2] = {{1, 9}, {3, 3}};

    TEST_ASSERT_EQUAL_INT32(9, result);
    TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), factors.count);

    for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
        TEST_ASSERT_EQUAL_UINT32_ARRAY(expected[i], factors.factors[i], 2);
    }
}

void test_find_the_smallest_palindrome_from_double_digit_factors(void) {
    TEST_IGNORE();

    factor_t factors = {0};
    const int32_t result = smallest(&factors, 10, 99);
    const uint32_t expected[][2] = {{11, 11}};

    TEST_ASSERT_EQUAL_INT32(121, result);
    TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), factors.count);

    for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
        TEST_ASSERT_EQUAL_UINT32_ARRAY(expected[i], factors.factors[i], 2);
    }
}

void test_find_the_largest_palindrome_from_double_digit_factors(void) {
    TEST_IGNORE();

    factor_t factors = {0};
    const int32_t result = largest(&factors, 10, 99);
    const uint32_t expected[][2] = {{91, 99}};

    TEST_ASSERT_EQUAL_INT32(9009, result);
    TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), factors.count);

    for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
        TEST_ASSERT_EQUAL_UINT32_ARRAY(expected[i], factors.factors[i], 2);
    }
}

void test_find_the_smallest_palindrome_from_triple_digit_factors(void) {
    TEST_IGNORE();

    factor_t factors = {0};
    const int32_t result = smallest(&factors, 100, 999);
    const uint32_t expected[][2] = {{101, 101}};

    TEST_ASSERT_EQUAL_INT32(10201, result);
    TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), factors.count);

    for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
        TEST_ASSERT_EQUAL_UINT32_ARRAY(expected[i], factors.factors[i], 2);
    }
}

void test_find_the_largest_palindrome_from_triple_digit_factors(void) {
    TEST_IGNORE();

    factor_t factors = {0};
    const int32_t result = largest(&factors, 100, 999);
    const uint32_t expected[][2] = {{913, 993}};

    TEST_ASSERT_EQUAL_INT32(906609, result);
    TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), factors.count);

    for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
        TEST_ASSERT_EQUAL_UINT32_ARRAY(expected[i], factors.factors[i], 2);
    }
}

void test_find_the_smallest_palindrome_from_four_digit_factors(void) {
    TEST_IGNORE();

    factor_t factors = {0};
    const int32_t result = smallest(&factors, 1000, 9999);
    const uint32_t expected[][2] = {{1001, 1001}};

    TEST_ASSERT_EQUAL_INT32(1002001, result);
    TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), factors.count);

    for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
        TEST_ASSERT_EQUAL_UINT32_ARRAY(expected[i], factors.factors[i], 2);
    }
}

void test_find_the_largest_palindrome_from_four_digit_factors(void) {
    TEST_IGNORE();

    factor_t factors = {0};
    const int32_t result = largest(&factors, 1000, 9999);
    const uint32_t expected[][2] = {{9901, 9999}};

    TEST_ASSERT_EQUAL_INT32(99000099, result);
    TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), factors.count);

    for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
        TEST_ASSERT_EQUAL_UINT32_ARRAY(expected[i], factors.factors[i], 2);
    }
}

void test_empty_result_for_smallest_if_no_palindrome_in_the_range(void) {
    TEST_IGNORE();

    factor_t factors = {0};
    TEST_ASSERT_EQUAL(EMPTY_RESULT, smallest(&factors, 1002, 1003));
}

void test_empty_result_for_largest_if_no_palindrome_in_the_range(void) {
    TEST_IGNORE();

    factor_t factors = {0};
    TEST_ASSERT_EQUAL(EMPTY_RESULT, largest(&factors, 15, 15));
}

void test_error_result_for_smallest_if_min_is_more_than_max(void) {
    TEST_IGNORE();

    factor_t factors = {0};
    TEST_ASSERT_EQUAL(INVALID_INPUT, smallest(&factors, 10000, 1));
}

void test_error_result_for_largest_if_min_is_more_than_max(void) {
    TEST_IGNORE();

    factor_t factors = {0};
    TEST_ASSERT_EQUAL(INVALID_INPUT, largest(&factors, 2, 1));
}

void test_smallest_product_does_not_use_the_smallest_factor(void) {
    TEST_IGNORE();

    factor_t factors = {0};
    const int32_t result = smallest(&factors, 3215, 4000);
    const uint32_t expected[][2] = {{3297, 3333}};

    TEST_ASSERT_EQUAL_INT32(10988901, result);
    TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), factors.count);

    for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
        TEST_ASSERT_EQUAL_UINT32_ARRAY(expected[i], factors.factors[i], 2);
    }
}

void test_find_the_smallest_palindrome_from_five_digit_factors(void) {
    TEST_IGNORE();

    factor_t factors = {0};
    const int32_t result = smallest(&factors, 54773, 63245);
    const uint32_t expected[][2] = {{54799, 55297}};

    TEST_ASSERT_EQUAL_INT32(3030220303, result);
    TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), factors.count);

    for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
        TEST_ASSERT_EQUAL_UINT32_ARRAY(expected[i], factors.factors[i], 2);
    }
}

void test_find_the_largest_palindrome_from_five_digit_factors(void) {
    TEST_IGNORE();

    factor_t factors = {0};
    const int32_t result = largest(&factors, 54773, 63245);
    const uint32_t expected[][2] = {{62799, 63007}};

    TEST_ASSERT_EQUAL_INT32(3956776593, result);
    TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), factors.count);

    for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
        TEST_ASSERT_EQUAL_UINT32_ARRAY(expected[i], factors.factors[i], 2);
    }
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_find_the_smallest_palindrome_from_single_digit_factors);
    RUN_TEST(test_find_the_largest_palindrome_from_single_digit_factors);
    RUN_TEST(test_find_the_smallest_palindrome_from_double_digit_factors);
    RUN_TEST(test_find_the_largest_palindrome_from_double_digit_factors);
    RUN_TEST(test_find_the_smallest_palindrome_from_triple_digit_factors);
    RUN_TEST(test_find_the_largest_palindrome_from_triple_digit_factors);
    RUN_TEST(test_find_the_smallest_palindrome_from_four_digit_factors);
    RUN_TEST(test_find_the_largest_palindrome_from_four_digit_factors);
    RUN_TEST(test_empty_result_for_smallest_if_no_palindrome_in_the_range);
    RUN_TEST(test_empty_result_for_largest_if_no_palindrome_in_the_range);
    RUN_TEST(test_error_result_for_smallest_if_min_is_more_than_max);
    RUN_TEST(test_error_result_for_largest_if_min_is_more_than_max);
    RUN_TEST(test_smallest_product_does_not_use_the_smallest_factor);
    RUN_TEST(test_find_the_smallest_palindrome_from_five_digit_factors);
    RUN_TEST(test_find_the_largest_palindrome_from_five_digit_factors);
    return UNITY_END();
}
