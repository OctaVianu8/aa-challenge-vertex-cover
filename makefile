CXX = g++
CXXFLAGS = -O2
CXXFLAGS_17 = -std=c++17 -O2

# Default algorithm
ALGORITHM ?= greedy-highest-order

EXECUTABLES = brute-force greedy-highest-order greedy-remove-edges test-gen-random calculate-accuracy

all: $(EXECUTABLES)

brute-force: brute-force.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

greedy-highest-order: greedy-highest-order.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

greedy-remove-edges: greedy-remove-edges.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

test-gen-random: test-gen-random.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

calculate-accuracy: calculate-accuracy.cpp
	$(CXX) $(CXXFLAGS_17) -o $@ $<

generate-tests: test-gen-random
	./generate-tests-random.sh 10

generate-ref: brute-force
	./generate-ref.sh

run-greedy: $(ALGORITHM)
	./run-greedy.sh $(ALGORITHM)

accuracy: calculate-accuracy
	./calculate-accuracy $(ALGORITHM)

pipeline: all
	./generate-tests-random.sh 30 30
	./generate-tests-random.sh 30 67
	./generate-tests-random.sh 30 10
	./generate-ref.sh
	./run-greedy.sh greedy-highest-order
	./run-greedy.sh greedy-remove-edges
	./calculate-accuracy greedy-highest-order
	./calculate-accuracy greedy-remove-edges

clean:
	rm -f $(EXECUTABLES)

clean-all: clean
	rm -rf ./in/*
	rm -rf ./ref/*
	rm -rf ./out/*

.PHONY: all clean clean-all generate-tests generate-ref run-greedy accuracy pipeline
