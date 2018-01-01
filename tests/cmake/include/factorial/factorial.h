#pragma once

namespace tl_base_ci {

  inline int factorial(int a_num)
  {
    if (a_num == 0 || a_num == 1)
    { return 1; }

    return a_num * factorial(a_num - 1);
  }

};
