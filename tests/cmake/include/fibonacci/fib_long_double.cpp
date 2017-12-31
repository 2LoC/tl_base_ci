#include "fib_long_double.h"

namespace tl_base_ci_tests {

  long double fibonacci(long double a_num)
  {
    if (a_num == 0 || a_num == 1)
    { return a_num; }

    return fibonacci(a_num - 1) + fibonacci(a_num - 2);
  }

};
