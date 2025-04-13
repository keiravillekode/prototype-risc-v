#include "vendor/unity.h"

#include <stddef.h>
#include <stdint.h>

#define MAX_ARRAY_SIZE 100
#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

extern size_t factors(uint32_t* dest, uint32_t value);

void setUp(void) {
}

void tearDown(void) {
}

void test_no_factors(void) {
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = factors(actual, 1);
    TEST_ASSERT_EQUAL_UINT(0U, size);
}

void test_prime_number(void) {
    TEST_IGNORE();
    const uint32_t expected[] = {2};
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = factors(actual, 2);
    TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);
}

void test_another_prime_number(void) {
    TEST_IGNORE();
    const uint32_t expected[] = {3};
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = factors(actual, 3);
    TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);
}

void test_square_of_a_prime(void) {
    TEST_IGNORE();
    const uint32_t expected[] = {3, 3};
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = factors(actual, 9);
    TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);
}

void test_product_of_first_prime(void) {
    TEST_IGNORE();
    const uint32_t expected[] = {2, 2};
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = factors(actual, 4);
    TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);
}

void test_cube_of_a_prime(void) {
    TEST_IGNORE();
    const uint32_t expected[] = {2, 2, 2};
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = factors(actual, 8);
    TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);
}

void test_product_of_second_prime(void) {
    TEST_IGNORE();
    const uint32_t expected[] = {3, 3, 3};
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = factors(actual, 27);
    TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);
}

void test_product_of_third_prime(void) {
    TEST_IGNORE();
    const uint32_t expected[] = {5, 5, 5, 5};
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = factors(actual, 625);
    TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);
}

void test_product_of_first_and_second_prime(void) {
    TEST_IGNORE();
    const uint32_t expected[] = {2, 3};
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = factors(actual, 6);
    TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);
}

void test_product_of_primes_and_nonprimes(void) {
    TEST_IGNORE();
    const uint32_t expected[] = {2, 2, 3};
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = factors(actual, 12);
    TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);
}

void test_product_of_primes(void) {
    TEST_IGNORE();
    const uint32_t expected[] = {5, 17, 23, 461};
    uint32_t actual[MAX_ARRAY_SIZE];
    const size_t size = factors(actual, 901255);
    TEST_ASSERT_EQUAL_UINT(ARRAY_SIZE(expected), size);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, size);
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_no_factors);
    RUN_TEST(test_prime_number);
    RUN_TEST(test_another_prime_number);
    RUN_TEST(test_square_of_a_prime);
    RUN_TEST(test_product_of_first_prime);
    RUN_TEST(test_cube_of_a_prime);
    RUN_TEST(test_product_of_second_prime);
    RUN_TEST(test_product_of_third_prime);
    RUN_TEST(test_product_of_first_and_second_prime);
    RUN_TEST(test_product_of_primes_and_nonprimes);
    RUN_TEST(test_product_of_primes);
    return UNITY_END();
}
