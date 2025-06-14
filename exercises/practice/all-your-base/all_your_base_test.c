#include "vendor/unity.h"

#include <stddef.h>
#include <stdint.h>

#define BUFFER_SIZE 100
#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
#define BAD_BASE -1
#define BAD_DIGIT -2

extern int rebase(int32_t in_base, const int32_t *in_digits, int in_digit_count, int32_t out_base, int32_t *out_digits);

void setUp(void) {
}

void tearDown(void) {
}

void test_single_bit_one_to_decimal(void) {
    const int32_t in_digits[] = {1};
    int32_t out_digits[BUFFER_SIZE];
    const int32_t expected[] = {1};

    TEST_ASSERT_EQUAL_INT(ARRAY_SIZE(expected), rebase(2, in_digits, ARRAY_SIZE(in_digits), 10, out_digits));
    TEST_ASSERT_EQUAL_INT_ARRAY(expected, out_digits, ARRAY_SIZE(expected));
}

void test_binary_to_single_decimal(void) {
    TEST_IGNORE();
    const int32_t in_digits[] = {1, 0, 1};
    int32_t out_digits[BUFFER_SIZE];
    const int32_t expected[] = {5};

    TEST_ASSERT_EQUAL_INT(ARRAY_SIZE(expected), rebase(2, in_digits, ARRAY_SIZE(in_digits), 10, out_digits));
    TEST_ASSERT_EQUAL_INT_ARRAY(expected, out_digits, ARRAY_SIZE(expected));
}

void test_single_decimal_to_binary(void) {
    TEST_IGNORE();
    const int32_t in_digits[] = {5};
    int32_t out_digits[BUFFER_SIZE];
    const int32_t expected[] = {1, 0, 1};

    TEST_ASSERT_EQUAL_INT(ARRAY_SIZE(expected), rebase(10, in_digits, ARRAY_SIZE(in_digits), 2, out_digits));
    TEST_ASSERT_EQUAL_INT_ARRAY(expected, out_digits, ARRAY_SIZE(expected));
}

void test_binary_to_multiple_decimal(void) {
    TEST_IGNORE();
    const int32_t in_digits[] = {1, 0, 1, 0, 1, 0};
    int32_t out_digits[BUFFER_SIZE];
    const int32_t expected[] = {4, 2};

    TEST_ASSERT_EQUAL_INT(ARRAY_SIZE(expected), rebase(2, in_digits, ARRAY_SIZE(in_digits), 10, out_digits));
    TEST_ASSERT_EQUAL_INT_ARRAY(expected, out_digits, ARRAY_SIZE(expected));
}

void test_decimal_to_binary(void) {
    TEST_IGNORE();
    const int32_t in_digits[] = {4, 2};
    int32_t out_digits[BUFFER_SIZE];
    const int32_t expected[] = {1, 0, 1, 0, 1, 0};

    TEST_ASSERT_EQUAL_INT(ARRAY_SIZE(expected), rebase(10, in_digits, ARRAY_SIZE(in_digits), 2, out_digits));
    TEST_ASSERT_EQUAL_INT_ARRAY(expected, out_digits, ARRAY_SIZE(expected));
}

void test_trinary_to_hexadecimal(void) {
    TEST_IGNORE();
    const int32_t in_digits[] = {1, 1, 2, 0};
    int32_t out_digits[BUFFER_SIZE];
    const int32_t expected[] = {2, 10};

    TEST_ASSERT_EQUAL_INT(ARRAY_SIZE(expected), rebase(3, in_digits, ARRAY_SIZE(in_digits), 16, out_digits));
    TEST_ASSERT_EQUAL_INT_ARRAY(expected, out_digits, ARRAY_SIZE(expected));
}

void test_hexadecimal_to_trinary(void) {
    TEST_IGNORE();
    const int32_t in_digits[] = {2, 10};
    int32_t out_digits[BUFFER_SIZE];
    const int32_t expected[] = {1, 1, 2, 0};

    TEST_ASSERT_EQUAL_INT(ARRAY_SIZE(expected), rebase(16, in_digits, ARRAY_SIZE(in_digits), 3, out_digits));
    TEST_ASSERT_EQUAL_INT_ARRAY(expected, out_digits, ARRAY_SIZE(expected));
}

void test_15bit_integer(void) {
    TEST_IGNORE();
    const int32_t in_digits[] = {3, 46, 60};
    int32_t out_digits[BUFFER_SIZE];
    const int32_t expected[] = {6, 10, 45};

    TEST_ASSERT_EQUAL_INT(ARRAY_SIZE(expected), rebase(97, in_digits, ARRAY_SIZE(in_digits), 73, out_digits));
    TEST_ASSERT_EQUAL_INT_ARRAY(expected, out_digits, ARRAY_SIZE(expected));
}

void test_empty_list(void) {
    TEST_IGNORE();
    const int32_t *in_digits = NULL;
    int32_t out_digits[BUFFER_SIZE];
    const int32_t expected[] = {0};

    TEST_ASSERT_EQUAL_INT(ARRAY_SIZE(expected), rebase(2, in_digits, 0, 10, out_digits));
    TEST_ASSERT_EQUAL_INT_ARRAY(expected, out_digits, ARRAY_SIZE(expected));
}

void test_single_zero(void) {
    TEST_IGNORE();
    const int32_t in_digits[] = {0};
    int32_t out_digits[BUFFER_SIZE];
    const int32_t expected[] = {0};

    TEST_ASSERT_EQUAL_INT(ARRAY_SIZE(expected), rebase(10, in_digits, ARRAY_SIZE(in_digits), 2, out_digits));
    TEST_ASSERT_EQUAL_INT_ARRAY(expected, out_digits, ARRAY_SIZE(expected));
}

void test_multiple_zeros(void) {
    TEST_IGNORE();
    const int32_t in_digits[] = {0, 0, 0};
    int32_t out_digits[BUFFER_SIZE];
    const int32_t expected[] = {0};

    TEST_ASSERT_EQUAL_INT(ARRAY_SIZE(expected), rebase(10, in_digits, ARRAY_SIZE(in_digits), 2, out_digits));
    TEST_ASSERT_EQUAL_INT_ARRAY(expected, out_digits, ARRAY_SIZE(expected));
}

void test_leading_zeros(void) {
    TEST_IGNORE();
    const int32_t in_digits[] = {0, 6, 0};
    int32_t out_digits[BUFFER_SIZE];
    const int32_t expected[] = {4, 2};

    TEST_ASSERT_EQUAL_INT(ARRAY_SIZE(expected), rebase(7, in_digits, ARRAY_SIZE(in_digits), 10, out_digits));
    TEST_ASSERT_EQUAL_INT_ARRAY(expected, out_digits, ARRAY_SIZE(expected));
}

void test_input_base_is_one(void) {
    TEST_IGNORE();
    const int32_t in_digits[] = {0};
    int32_t out_digits[BUFFER_SIZE];

    TEST_ASSERT_EQUAL_INT(BAD_BASE, rebase(1, in_digits, ARRAY_SIZE(in_digits), 10, out_digits));
}

void test_input_base_is_zero(void) {
    TEST_IGNORE();
    const int32_t *in_digits = NULL;
    int32_t out_digits[BUFFER_SIZE];

    TEST_ASSERT_EQUAL_INT(BAD_BASE, rebase(0, in_digits, 0, 10, out_digits));
}

void test_input_base_is_negative(void) {
    TEST_IGNORE();
    const int32_t in_digits[] = {1};
    int32_t out_digits[BUFFER_SIZE];

    TEST_ASSERT_EQUAL_INT(BAD_BASE, rebase(-2, in_digits, ARRAY_SIZE(in_digits), 10, out_digits));
}

void test_negative_digit(void) {
    TEST_IGNORE();
    const int32_t in_digits[] = {1, -1, 1, 0, 1, 0};
    int32_t out_digits[BUFFER_SIZE];

    TEST_ASSERT_EQUAL_INT(BAD_DIGIT, rebase(2, in_digits, ARRAY_SIZE(in_digits), 10, out_digits));
}

void test_invalid_positive_digit(void) {
    TEST_IGNORE();
    const int32_t in_digits[] = {1, 2, 1, 0, 1, 0};
    int32_t out_digits[BUFFER_SIZE];

    TEST_ASSERT_EQUAL_INT(BAD_DIGIT, rebase(2, in_digits, ARRAY_SIZE(in_digits), 10, out_digits));
}

void test_output_base_is_one(void) {
    TEST_IGNORE();
    const int32_t in_digits[] = {1, 0, 1, 0, 1, 0};
    int32_t out_digits[BUFFER_SIZE];

    TEST_ASSERT_EQUAL_INT(BAD_BASE, rebase(2, in_digits, ARRAY_SIZE(in_digits), 1, out_digits));
}

void test_output_base_is_zero(void) {
    TEST_IGNORE();
    const int32_t in_digits[] = {7};
    int32_t out_digits[BUFFER_SIZE];

    TEST_ASSERT_EQUAL_INT(BAD_BASE, rebase(10, in_digits, ARRAY_SIZE(in_digits), 0, out_digits));
}

void test_output_base_is_negative(void) {
    TEST_IGNORE();
    const int32_t in_digits[] = {1};
    int32_t out_digits[BUFFER_SIZE];

    TEST_ASSERT_EQUAL_INT(BAD_BASE, rebase(2, in_digits, ARRAY_SIZE(in_digits), -7, out_digits));
}

void test_both_bases_are_negative(void) {
    TEST_IGNORE();
    const int32_t in_digits[] = {1};
    int32_t out_digits[BUFFER_SIZE];

    TEST_ASSERT_EQUAL_INT(BAD_BASE, rebase(-2, in_digits, ARRAY_SIZE(in_digits), -7, out_digits));
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_single_bit_one_to_decimal);
    RUN_TEST(test_binary_to_single_decimal);
    RUN_TEST(test_single_decimal_to_binary);
    RUN_TEST(test_binary_to_multiple_decimal);
    RUN_TEST(test_decimal_to_binary);
    RUN_TEST(test_trinary_to_hexadecimal);
    RUN_TEST(test_hexadecimal_to_trinary);
    RUN_TEST(test_15bit_integer);
    RUN_TEST(test_empty_list);
    RUN_TEST(test_single_zero);
    RUN_TEST(test_multiple_zeros);
    RUN_TEST(test_leading_zeros);
    RUN_TEST(test_input_base_is_one);
    RUN_TEST(test_input_base_is_zero);
    RUN_TEST(test_input_base_is_negative);
    RUN_TEST(test_negative_digit);
    RUN_TEST(test_invalid_positive_digit);
    RUN_TEST(test_output_base_is_one);
    RUN_TEST(test_output_base_is_zero);
    RUN_TEST(test_output_base_is_negative);
    RUN_TEST(test_both_bases_are_negative);
    return UNITY_END();
}
