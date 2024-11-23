//
// markovChain.h
//

#include "intMath.h"
#ifndef INT_MATH_H
#error "This module requires the intMath module."
#error "https://github.com/diegesisandmimesis/intMath"
#error "It should be in the same parent directory as this module.  So if"
#error "markovChain is in /home/user/tads/markovChain, then"
#error "intMath should be in /home/user/tads/intMath ."
#endif // INT_MATH_H

#include "simpleGraph.h"
#ifndef SIMPLE_GRAPH_H
#error "This module requires the simpleGraph module."
#error "https://github.com/diegesisandmimesis/simpleGraph"
#error "It should be in the same parent directory as this module.  So if"
#error "markovChain is in /home/user/tads/markovChain, then"
#error "simpleGraph should be in /home/user/tads/simpleGraph ."
#endif // SIMPLE_GRAPH_H

#include "notReallyRandom.h"
#ifndef NOT_REALLY_RANDOM_H
#error "This module requires the notReallyRandom module."
#error "https://github.com/diegesisandmimesis/notReallyRandom"
#error "It should be in the same parent directory as this module.  So if"
#error "markovChain is in /home/user/tads/markovChain, then"
#error "notReallyRandom should be in /home/user/tads/notReallyRandom ."
#endif // NOT_REALLY_RANDOM_H

#ifdef LINTER
#ifdef __DEBUG
#include "linter.h"
#ifndef LINTER_H
#error "This module requires the linter module."
#error "https://github.com/diegesisandmimesis/linter"
#error "It should be in the same parent directory as this module.  So if"
#error "markovChain is in /home/user/tads/markovChain, then"
#error "linter should be in /home/user/tads/linter ."
#endif // LINTER_H
#endif // __DEBUG
#endif // LINTER

MarkovChain template '_currentStateID'? @_currentState?;
MarkovState template 'id'?;
MarkovTransition template ->_vertex1 +_length?;


#define MARKOV_CHAIN_H
