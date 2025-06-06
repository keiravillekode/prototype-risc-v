#include "vendor/unity.h"

#include <stdint.h>

typedef enum {
    INVALID = 0,
    DEFICIENT,
    PERFECT,
    ABUNDANT,
} category_t;

extern category_t classify(int number);

void setUp(void) {
}

void tearDown(void) {
}

void test_smallest_perfect_number_is_classified_correctly(void) {
    TEST_ASSERT_EQUAL_INT(PERFECT, classify(6));
}

void test_medium_perfect_number_is_classified_correctly(void) {
    TEST_IGNORE();
    TEST_ASSERT_EQUAL_INT(PERFECT, classify(28));
}

void test_large_perfect_number_is_classified_correctly(void) {
    TEST_IGNORE();
    TEST_ASSERT_EQUAL_INT(PERFECT, classify(33550336));
}

void test_smallest_abundant_number_is_classified_correctly(void) {
    TEST_IGNORE();
    TEST_ASSERT_EQUAL_INT(ABUNDANT, classify(12));
}

void test_medium_abundant_number_is_classified_correctly(void) {
    TEST_IGNORE();
    TEST_ASSERT_EQUAL_INT(ABUNDANT, classify(30));
}

void test_large_abundant_number_is_classified_correctly(void) {
    TEST_IGNORE();
    TEST_ASSERT_EQUAL_INT(ABUNDANT, classify(33550335));
}

void test_smallest_prime_deficient_number_is_classified_correctly(void) {
    TEST_IGNORE();
    TEST_ASSERT_EQUAL_INT(DEFICIENT, classify(2));
}

void test_smallest_nonprime_deficient_number_is_classified_correctly(void) {
    TEST_IGNORE();
    TEST_ASSERT_EQUAL_INT(DEFICIENT, classify(4));
}

void test_medium_deficient_number_is_classified_correctly(void) {
    TEST_IGNORE();
    TEST_ASSERT_EQUAL_INT(DEFICIENT, classify(32));
}

void test_large_deficient_number_is_classified_correctly(void) {
    TEST_IGNORE();
    TEST_ASSERT_EQUAL_INT(DEFICIENT, classify(33550337));
}

void test_edge_case_no_factors_other_than_itself_is_classified_correctly(void) {
    TEST_IGNORE();
    TEST_ASSERT_EQUAL_INT(DEFICIENT, classify(1));
}

void test_zero_is_rejected_as_it_is_not_a_positive_integer(void) {
    TEST_IGNORE();
    TEST_ASSERT_EQUAL_INT(INVALID, classify(0));
}

void test_negative_integer_is_rejected_as_it_is_not_a_positive_integer(void) {
    TEST_IGNORE();
    TEST_ASSERT_EQUAL_INT(INVALID, classify(-1));
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_smallest_perfect_number_is_classified_correctly);
    RUN_TEST(test_medium_perfect_number_is_classified_correctly);
    RUN_TEST(test_large_perfect_number_is_classified_correctly);
    RUN_TEST(test_smallest_abundant_number_is_classified_correctly);
    RUN_TEST(test_medium_abundant_number_is_classified_correctly);
    RUN_TEST(test_large_abundant_number_is_classified_correctly);
    RUN_TEST(test_smallest_prime_deficient_number_is_classified_correctly);
    RUN_TEST(test_smallest_nonprime_deficient_number_is_classified_correctly);
    RUN_TEST(test_medium_deficient_number_is_classified_correctly);
    RUN_TEST(test_large_deficient_number_is_classified_correctly);
    RUN_TEST(test_edge_case_no_factors_other_than_itself_is_classified_correctly);
    RUN_TEST(test_zero_is_rejected_as_it_is_not_a_positive_integer);
    RUN_TEST(test_negative_integer_is_rejected_as_it_is_not_a_positive_integer);
    return UNITY_END();
}
