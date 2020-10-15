#include <benchmark/benchmark.h>
#include <random>
#include <vector>

/******************************************************************************
@link: [https://www.youtube.com/watch?v=nXaxk27zwlk](CppCon 2015: Chandler
Carruth "Tuning C++: Benchmarks, and CPUs, and Compilers! Oh My!")
@note: Compiler improvements must have been made because fastmod is no longer
faster than simple mod
******************************************************************************/

static void generate_arg_pairs(benchmark::internal::Benchmark *b) {
	for (int i = 1 << 4; i <= 1 << 10; i <<= 2) {
		for (int j : {32, 128, 224}) {
			b = b->ArgPair(i, j);
		}
	}
}

static void bench_mod(benchmark::State &state) {
	const std::size_t size = static_cast<std::size_t>(state.range(0));
	const int ceil = static_cast<int>(state.range(1));
	std::vector<int> input, output;
	input.resize(size, 0);
	output.resize(size, 0);

	std::mt19937 rng;
	rng.seed(std::random_device()());
	std::uniform_int_distribution<int> dist(0, 255);
	for (int &i : input)
		i = dist(rng);

	assert(size >= 16 && "Only support 16 integers at a time!");

	while (state.KeepRunning()) {
		for (auto i = 0u; i < size; i += 4) {
			output[i] = input[i] % ceil;
		}
	}
}

BENCHMARK(bench_mod)->Apply(generate_arg_pairs);

// #define UNLIKELY(x) __builtin_expect((bool)(x), 0) // doesn't compile
#define UNLIKELY(x) __builtin_expect((x), 0)
// #define UNLIKELY(x) x

static void bench_fastmod(benchmark::State &state) {
	const std::size_t size = static_cast<std::size_t>(state.range(0));
	const int ceil = static_cast<int>(state.range(1));
	std::vector<int> input, output;
	input.resize(size, 0);
	output.resize(size, 0);

	std::mt19937 rng;
	rng.seed(std::random_device()());
	std::uniform_int_distribution<int> dist(0, 255);
	for (int &i : input)
		i = dist(rng);

	assert(size >= 16 && "Only support 16 integers at a time!");

	while (state.KeepRunning()) {
		// This for loop is unfolded by the compiler's optimizer
		for (auto i = 0u; i < size; ++i) {
			output[i] = input[i] >= ceil ? input[i] % ceil : input[i];
		}

		/* This for loop won't be faster because the instruction cache may miss
		 * a cache line */
		/*
		for (auto i = 0u; i < size; i += 4) {
#define mod(o) \
	output[i + o] = \ UNLIKELY(input[i + o] >= ceil) ? input[i + o] % ceil :
input[i + o]; mod(0); mod(1); mod(2); mod(3);
		}
		*/
	}
}

BENCHMARK(bench_fastmod)->Apply(generate_arg_pairs);

BENCHMARK_MAIN();