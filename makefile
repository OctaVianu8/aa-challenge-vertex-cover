CXX = g++
CXXFLAGS = -O2
CXXFLAGS_17 = -std=c++17 -O2

EXECUTABLES = brute-force greedy-highest-order test-gen-random calculate-accuracy

all: $(EXECUTABLES)

brute-force: brute-force.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

greedy-highest-order: greedy-highest-order.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

test-gen-random: test-gen-random.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

calculate-accuracy: calculate-accuracy.cpp
	$(CXX) $(CXXFLAGS_17) -o $@ $<

generate-tests: test-gen-random
	./generate-tests-random.sh 10

generate-ref: brute-force
	./generate-ref.sh

run-greedy: greedy-highest-order
	./run-highest-order-greedy.sh

accuracy: calculate-accuracy
	./calculate-accuracy

pipeline: all
	./generate-tests-random.sh 100
	./generate-ref.sh
	./run-highest-order-greedy.sh
	./calculate-accuracy

clean:
	rm -f $(EXECUTABLES)

clean-all: clean
	rm -rf ./in/random/*.in
	rm -rf ./ref/random/*.ref
	rm -rf ./out/greedy-highest-order/*.out

.PHONY: all clean clean-all generate-tests generate-ref run-greedy accuracy pipeline
