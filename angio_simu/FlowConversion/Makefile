.SUFFIXES:
.PHONY: clean mrproper

CXX=g++
CXXFLAGS=-W -Wall -O3
LDFLAGS=
EXEC=CreateParticleTracer
SRC= $(wildcard *.cpp)
OBJ= $(SRC:.cpp=.o)

all: $(EXEC)

CreateParticleTracer: $(OBJ)
	$(CXX) -o $@ $^ $(LDFLAGS)

CreateParticleTracer.o: header.hpp

%.o: %.cpp
	$(CXX) -o $@ -c $< $(CXXFLAGS)

clean:
	rm -rf *.o

mrproper: clean
	rm -rf $(EXEC)
	rm -rf ParticleTracer.py
	rm -rf ProgrammableSource_*.py
	rm -rf ProgrammableFilter_*.py
	rm -rf PT.pvd
			
