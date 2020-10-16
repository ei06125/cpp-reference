#include <benchmark/benchmark.h>
#include <vector>

/******************************************************************************
@link: [https://www.youtube.com/watch?v=nXaxk27zwlk](CppCon 2015: Chandler
Carruth "Tuning C++: Benchmarks, and CPUs, and Compilers! Oh My!")
******************************************************************************/

/**
 * @brief Magical escape function that:
 * - Accepts an arbitary pointer and discard all type information
 * - `volatile` states that the assembly code has unknowable side-effects
 *
 * @param p
 */
static void escape(void *p) {
	// potentially modified all code in the program
	// asm syntax goes like (output, input, clubbers);
	asm volatile("" : : "g"(p) : "memory");
}

/**
 * @brief Fakes a volatile write on all memory, preventing optimization
 */
static void clobber() {
	// magically write to all memory
	asm volatile("" : : : "memory");
}

static void bench_create(benchmark::State &state) {
	while (state.KeepRunning()) {
		std::vector<int> v;
		escape(&v);
		(void)v;
	}
}

BENCHMARK(bench_create);

static void bench_reserve(benchmark::State &state) {
	while (state.KeepRunning()) {
		std::vector<int> v;
		v.reserve(1);
		escape(v.data()); // escape the allocated data (not the vector)
	}
}

BENCHMARK(bench_reserve);

static void bench_push_back(benchmark::State &state) {
	while (state.KeepRunning()) {
		std::vector<int> v;
		v.reserve(1);
		escape(v.data()); // escape the allocated data (not the vector)
		v.push_back(42);
		clobber();
	}
}

BENCHMARK(bench_push_back);