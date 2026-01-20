CXX = g++
CXXFLAGS = -O2
CXXFLAGS_17 = -std=c++17 -O2

# Directories
SRC_DIR = src
BIN_DIR = bin
SCRIPTS_DIR = scripts
TESTS_DIR = tests

# Default algorithm
ALGORITHM ?= greedy-highest-order

COUNT ?= 10

EXECUTABLES = $(BIN_DIR)/brute-force $(BIN_DIR)/greedy-highest-order $(BIN_DIR)/greedy-remove-edges $(BIN_DIR)/test-gen-random $(BIN_DIR)/test-gen-cycle-with-cords $(BIN_DIR)/test-gen-bipartite $(BIN_DIR)/calculate-accuracy

all: $(BIN_DIR) $(EXECUTABLES)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(BIN_DIR)/brute-force: $(SRC_DIR)/brute-force.cpp | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $<

$(BIN_DIR)/greedy-highest-order: $(SRC_DIR)/greedy-highest-order.cpp | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $<

$(BIN_DIR)/greedy-remove-edges: $(SRC_DIR)/greedy-remove-edges.cpp | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $<

$(BIN_DIR)/test-gen-random: $(SRC_DIR)/test-gen-random.cpp | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $<

$(BIN_DIR)/test-gen-cycle-with-cords: $(SRC_DIR)/test-gen-cycle-with-cords.cpp | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $<

$(BIN_DIR)/test-gen-bipartite: $(SRC_DIR)/test-gen-bipartite.cpp | $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $<

$(BIN_DIR)/calculate-accuracy: $(SRC_DIR)/calculate-accuracy.cpp | $(BIN_DIR)
	$(CXX) $(CXXFLAGS_17) -o $@ $<

$(BIN_DIR)/calculate-google-benchmark: $(SRC_DIR)/calculate-google-benchmark.cpp | $(BIN_DIR)
	$(CXX) $(CXXFLAGS_17) -DUSE_BENCHMARK -I./benchmark/include -L./benchmark/build/src -o $@ $< -lbenchmark_main -lbenchmark -lpthread -ldl -lm

generate-tests: $(BIN_DIR)/test-gen-random
	$(SCRIPTS_DIR)/generate-tests-random.sh 10

generate-ref: $(BIN_DIR)/brute-force
	$(SCRIPTS_DIR)/generate-ref.sh

pipeline: all
	$(SCRIPTS_DIR)/generate-tests-random.sh $(COUNT) 30
	$(SCRIPTS_DIR)/generate-tests-random.sh $(COUNT) 67
	$(SCRIPTS_DIR)/generate-tests-random.sh $(COUNT) 10
	$(SCRIPTS_DIR)/generate-tests-cycle-with-cords.sh $(COUNT)
	$(SCRIPTS_DIR)/generate-tests-bipartite.sh $(COUNT)
	$(SCRIPTS_DIR)/generate-ref.sh
	$(SCRIPTS_DIR)/run-greedy.sh greedy-highest-order
	$(SCRIPTS_DIR)/run-greedy.sh greedy-remove-edges
	@echo ""
	@echo "=== RESULTS ==="
	@$(BIN_DIR)/calculate-accuracy greedy-highest-order
	@$(BIN_DIR)/calculate-accuracy greedy-remove-edges
	@echo "[brute-force] (Time: $$(cat $(TESTS_DIR)/ref/.time)s)"
	@echo "  TOTAL  : Tests: $$(find $(TESTS_DIR)/ref -name '*.ref' | wc -l) | Perfect: 100.0% | Avg: 100.00%"

clean:
	rm -rf $(BIN_DIR)

clean-all: clean
	rm -rf $(TESTS_DIR)/in/*
	rm -rf $(TESTS_DIR)/ref/*
	rm -rf $(TESTS_DIR)/out/*

.PHONY: all clean clean-all generate-tests generate-ref run-greedy accuracy pipeline
