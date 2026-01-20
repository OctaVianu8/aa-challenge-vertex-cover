CXX = g++
CXXFLAGS = -O2
CXXFLAGS_17 = -std=c++17 -O2

# Default algorithm
ALGORITHM ?= greedy-highest-order

COUNT ?= 10

EXECUTABLES = brute-force greedy-highest-order greedy-remove-edges test-gen-random test-gen-cycle-with-cords test-gen-bipartite calculate-accuracy

all: $(EXECUTABLES)

brute-force: brute-force.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

greedy-highest-order: greedy-highest-order.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

greedy-remove-edges: greedy-remove-edges.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

test-gen-random: test-gen-random.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

test-gen-cycle-with-cords: test-gen-cycle-with-cords.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

test-gen-bipartite: test-gen-bipartite.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

calculate-accuracy: calculate-accuracy.cpp
	$(CXX) $(CXXFLAGS_17) -o $@ $<

calculate-benchmark: calculate-benchmark.cpp
	$(CXX) $(CXXFLAGS_17) -DUSE_BENCHMARK -I./benchmark/include -L./benchmark/build/src -o $@ $< -lbenchmark_main -lbenchmark -lpthread -ldl -lm

generate-tests: test-gen-random
	./generate-tests-random.sh 10

generate-ref: brute-force
	./generate-ref.sh

pipeline: all
	./generate-tests-random.sh $(COUNT) 30
	./generate-tests-random.sh $(COUNT) 67
	./generate-tests-random.sh $(COUNT) 10
	./generate-tests-cycle-with-cords.sh $(COUNT)
	./generate-tests-bipartite.sh $(COUNT)
	./generate-ref.sh
	./run-greedy.sh greedy-highest-order
	./run-greedy.sh greedy-remove-edges
	@echo ""
	@echo "=== RESULTS ==="
	@./calculate-accuracy greedy-highest-order
	@./calculate-accuracy greedy-remove-edges
	@echo "[brute-force] (Time: $$(cat ./ref/.time)s)"
	@echo "  TOTAL  : Tests: $$(find ./ref -name '*.ref' | wc -l) | Perfect: 100.0% | Avg: 100.00%"

clean:
	rm -f $(EXECUTABLES)

clean-all: clean
	rm -rf ./in/*
	rm -rf ./ref/*
	rm -rf ./out/*

.PHONY: all clean clean-all generate-tests generate-ref run-greedy accuracy pipeline
