#include <fibonacci_test/main.h>

#include <cassert>

template <typename T>
void test_fib()
{
  using tl_base_ci_tests::fibonacci;

  assert(fibonacci(T(0)) == T(0));
  assert(fibonacci(T(1)) == T(1));
  assert(fibonacci(T(2)) == T(1));
  assert(fibonacci(T(3)) == T(2));
  assert(fibonacci(T(4)) == T(3));
  assert(fibonacci(T(5)) == T(5));
  assert(fibonacci(T(6)) == T(8));
  assert(fibonacci(T(7)) == T(13));
  assert(fibonacci(T(8)) == T(21));
  assert(fibonacci(T(9)) == T(34));
  assert(fibonacci(T(10)) == T(55));
}

int main()
{
  test_fib<int>();
  test_fib<float>();
  test_fib<double>();
  test_fib<long double>();

  return 0;
}
