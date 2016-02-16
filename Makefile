# NOTE: needs boost, tclap, and sdsl

CXX=clang++ # g++
CPP_FLAGS=-m64 -std=c++0x -W -Wall -Wextra -Wpointer-arith -Wcast-qual \
					-Wstrict-prototypes -Wmissing-prototypes -Wwrite-strings \
#					-Wbool-conversions -Wshift-overflow -Wliteral-conversion \
					-Werror -W
DEP_PATH=/usr/local
INC_PATH=$(DEP_PATH)/include
LIB_PATH=$(DEP_PATH)/lib
MM_PATH=/s/chopin/l/grad/muggli/local

DEP_FLAGS=-I$(HOME)/proot/include -isystem $(MM_PATH)/include -L$(MM_PATH)/lib -I$(INC_PATH)/ -L$(HOME)/proot/lib -L$(LIB_PATH)/ -lsdsl # -ldivsufsort -ldivsufsort64
DEBUG_FLAGS=-g
NDEBUG_FLAGS=-DNDEBUG
OPT_FLAGS=-O3 -mmmx -msse -msse2 -msse3 -msse4 -msse4.2 -march=native
NOPT_FLAGS=-O0
NUM_COLS=64
# Using Semantic Versioning: http://semver.org/
VERSION=0.5.1
CPP_FLAGS+=-DVERSION=\"$(VERSION)\" -DNUM_COLS=$(NUM_COLS)

ifeq ($(optimise),0)
CPP_FLAGS+=$(NOPT_FLAGS)
else
CPP_FLAGS+=$(OPT_FLAGS)
endif

ifeq ($(debug),1)
CPP_FLAGS+=$(DEBUG_FLAGS)
else
CPP_FLAGS+=$(NDEBUG_FLAGS)
endif

ifeq ($(verbose),1)
CPP_FLAGS+=-DVERBOSE
endif

ifneq ($(revcomps),0)
CPP_FLAGS+=-DADD_REVCOMPS
endif

ifneq ($(dummies),0)
CPP_FLAGS+=-DALL_DUMMIES
endif

ifeq ($(varord),1)
CPP_FLAGS+=-DVAR_ORDER
endif

BUILD_REQS=debruijn_graph.hpp io.hpp io.o debug.h
COLOR_REQS=colored_debruijn_graph.hpp io.hpp io.o debug.h
ASSEM_REQS=debruijn_graph.hpp algorithm.hpp utility.hpp kmer.hpp uint128_t.hpp
PACK_REQS=lut.hpp debug.h io.hpp io.o sort.hpp kmer.hpp dummies.hpp
BINARIES=cosmo-pack cosmo-build cosmo-color cosmo-benchmark pack-color #match-color # cosmo-assemble

default: all

lut.hpp: make_lut.py
		python make_lut.py > lut.hpp

io.o: io.hpp io.cpp debug.h dummies.hpp kmer.hpp
		$(CXX) $(CPP_FLAGS) -c io.cpp

# TODO: Roll these all into one... "cosmo"
cosmo-pack: cosmo-pack.cpp $(PACK_REQS)
		$(CXX) $(CPP_FLAGS) -o $@ $< io.o $(DEP_FLAGS) 

cosmo-build: cosmo-build.cpp $(BUILD_REQS)
		$(CXX) $(CPP_FLAGS) -o $@ $< io.o $(DEP_FLAGS) 

cosmo-color: cosmo-color.cpp $(BUILD_REQS)
		$(CXX) $(CPP_FLAGS) -o $@ $< io.o $(DEP_FLAGS) 

pack-color: pack-color.cpp $(BUILD_REQS)
		$(CXX) $(CPP_FLAGS) -o $@ $< io.o $(DEP_FLAGS) 

#match-color: match-color.cpp $(BUILD_REQS)
#		$(CXX) $(CPP_FLAGS) -o $@ $< io.o $(DEP_FLAGS) 

#cosmo-assemble: cosmo-assemble.cpp $(ASSEM_REQS) wt_algorithm.hpp debruijn_hypergraph.hpp
#		$(CXX) $(CPP_FLAGS) -o $@ $< $(DEP_FLAGS) 

cosmo-benchmark: cosmo-benchmark.cpp $(ASSEM_REQS) wt_algorithm.hpp debruijn_hypergraph.hpp
		$(CXX) $(CPP_FLAGS) -o $@ $< $(DEP_FLAGS) 

all: $(BINARIES)

clean:
		rm -rf $(BINARIES) *.o *.dSYM
