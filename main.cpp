#include "pch.hpp"

class TestClass {
  public:
	TestClass() = default;
};

/******************************************************************************
 * @brief Application entry point
 * - The main function builds the objects necessary for the system,
 * ... then passes them to the application, which simply uses them.
 *****************************************************************************/
int main() {
	[out = std::ref(std::cout << "Hello ")]() { out.get() << "Pedro\n"; }();
	return 0;
}
