//
// markovChain.h
//

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

MarkovChain template '_currentNode';
MarkovState template 'id'?;
MarkovTransition template ->_vertex1 +_length?;


#define MARKOV_CHAIN_H
