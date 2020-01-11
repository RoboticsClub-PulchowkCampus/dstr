/*
 * slice_test.cpp
 * 
 * Created: 12/3/2019
 *  Author: n-is
 *   Email: 073bex422.nischal@pcampus.edu.np
 */

#include "slice.h"

#include "catch2/catch.hpp"

TEST_CASE("Testing Slice", "[slice]") {

        Slice<int> values {10, 20};

        int v = values[0];

        REQUIRE(v == 10);

        values[1] += 2;

        REQUIRE(values[1] == 22);
        REQUIRE(values.len() == 2);
        REQUIRE(values.cap() == DEFAULT_SLICE_SIZE);
}
