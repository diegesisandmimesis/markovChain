#charset "us-ascii"
//
// markovChain.t
//
//	A TADS3/adv3 module implementing simple discrete Markov chains.
//
//	In this module Markov chains are modelled as graphs using the
//	simpleGraph module.  Each state is a vertex, and each transition
//	is an edge, with the length of the edge used as a transition
//	weight.
//
//	Transition weights can either be given as decimal probabilities
//	(0.1 for 10%, 0.75 for 75%, and so on) or as integer weights.
//	If decimal probabilities are used, they are automagically converted
//	to integer weights during preinit for performance reasons.
//
//	Transitions are picked by adding up the integer weights for all
//	possible transitions and then picking a random integer between one
//	and the sum.
//
//
// USAGE
//
//	Declare a chain:
//
//		// Declare a chain myChain with initial state foo.
//		myChain: MarkovChain @foo;
//
//		// Declare the state foo, which transitions to bar
//		// 75% of the time and baz 25% of the time.
//		+foo: MarkovState 'foo';
//		++MarkovTransition ->bar +0.75;
//		++MarkovTransition ->baz +0.25;
//
//		// Declare the state bar, which transitions to foo
//		// 75% of the time and baz 25% of the time.  These are
//		// the same probabilities as the example above, only using
//		// integer weights instead of decimal probabilties.
//		+bar: MarkovState 'bar';
//		++MarkovTransition ->foo +300;
//		++MarkovTransition ->baz +100;
//
//		// Declare the state baz, which transitions to foo or bar
//		// with equal probability.
//		+baz: MarkovState 'baz';
//		++MarkovTransition ->foo +100;
//		++MarkovTransition ->bar +100;
//
//	Having declared the chain, transitions can be randomly selected
// 	via MarkovChain.pickTransition():
//
//		// The new state ID will be stored in id.
//		id = myChain.pickTransition();
//
//
#include <adv3.h>
#include <en_us.h>

// Module ID for the library
markovChainModuleID: ModuleID {
        name = 'Markov Chain Library'
        byline = 'Diegesis & Mimesis'
        version = '1.0'
        listingOrder = 99
}

// The base Markov chain object is a directed graph.
class MarkovChain: SimpleGraphDirected
	// Our bespoke vertex and edge classes.
	vertexClass = MarkovState
	edgeClass = MarkovTransition

	// Keep track of the chain's current state (which is just a
	// vertex in the graph).
	_currentStateID = nil
	_currentState = nil

	// Optional PRNG instance to use for rolling for transitions.
	_prng = nil

	setPRNG(v) { _prng = v; }

	// Returns the weight for the transition FROM the first ID TO
	// the second ID.
	getWeight(v0, v1) {
		local e;

		if((e = getEdge(v0, v1)) == nil) return(nil);
		return(e.getWeight());
	}

	// Sets the weight for the transition FROM v0 TO v1 (where
	// v0 and v1 are vertex IDs).
	setWeight(v0, v1, w) {
		local e;

		if((e = getEdge(v0, v1)) == nil) return(nil);
		e.setWeight(w);
		return(true);
	}

	// Pick a transition.  Arg is an optional vertex ID to transition
	// FROM.  Default is the current chain state.
	pickTransition(id?, prng?) {
		local v;

		// If no arg was given, use the current chain state.
		if(id == nil) {
			if(_currentStateID != nil)
				id = _currentStateID;
			else if(_currentState != nil)
				id = _currentState.id;
		}

		// If we still have no ID, give up in disgust.
		if(id == nil) return(nil);

		// Get the vertex with the given ID or die trying.
		if((v = getVertex(id)) == nil) return(nil);

		// Ask the vertex to pick a transition.
		if((id = v.pickTransition(prng ? prng : _prng)) == nil)
			return(nil);

		// Update the current state.
		_currentStateID = id;
		_currentState = v;

		// Return the result.
		return(_currentStateID);
	}
;

// Each state is just a graph vertex with some new methods to treat
// edge lengths as transition weights.
class MarkovState: SimpleGraphVertex
	// Get all of our possible transitions.  This will be a List
	// containing MarkovEdge instances.
	getTransitions() { return(edgeList()); }

	// Pick a transition from this state.  Optional arg is the PRNG
	// instance to use for the picking.
	pickTransition(prng?) {
		local l, v, w;

		// Get a list of all possible transitions.
		l = getTransitions();

		// Create a vector for the vertex IDs and another for
		// the transition weights.
		v = new Vector(l.length);
		w = new Vector(l.length);

		// Populate the lists.
		l.forEach(function(o) {
			v.append(o._vertex1.id);
			w.append(o.getWeight());
		});

		// Pick a random element from the vertex ID list using
		// the transition weights.
		return(randomElementWeighted(v, w, prng));
	}
;

// A state transition is just a graph edge where the length is the
// transition weight.
class MarkovTransition: SimpleGraphEdge
	// The baseWeight is used to assign integer weights for
	// transition declarations use decimal probabilties.
	// That is, if there are two states with transition probabilities
	// of 0.75 and 0.25, they'll be multiplied by 1000 (by default)
	// to yeild weights of 750 and 250, respectively.
	baseWeight = 1000

	// Getter and setter for the weight.  Pure semantic sugar.
	getWeight() { return(getLength()); }
	setWeight(v) { return(setLength(v)); }

	// Tweak the stock edge initialization method to add a check
	// for the weight.
	initializeEdge() {
		inherited();
		_fixWeight();
	}

	// Check to see if the weights were declared as decimal
	// probabilities.  If so, convert to integer weights.
	_fixWeight() {
		// No length, nothing to do.
		if(_length == nil) return;

		// If the length isn't between 0 and 1, it's not
		// a decimal probability;  nothing to do.
		if((_length == 0) || (_length > 1))
			return;

		// Convert the decimal probability to an integer weight
		// by multiplying it by the base weight.
		_length = toIntegerSafe(_length * baseWeight);
	}
;
