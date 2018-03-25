#include <factorial/factorial.h>

#define CATCH_CONFIG_MAIN
#include <catch.hpp>

TEST_CASE("Factorial test", "")
{
  CHECK(tl_base_ci::factorial(5) == 120);
}
