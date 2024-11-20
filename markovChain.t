#charset "us-ascii"
//
// markovChain.t
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

class MarkovChain: SimpleGraphDirected
	vertexClass = MarkovState
	edgeClass = MarkovTransition

	_currentNode = nil
	_prng = nil

	getWeight(v0, v1) {
		local e;

		if((e = getEdge(v0, v1)) == nil) return(nil);
		return(e.getWeight());
	}
	setWeight(v0, v1, w) {
		local e;

		if((e = getEdge(v0, v1)) == nil) return(nil);
		e.setWeight(w);
		return(true);
	}
	pickTransition(id?) {
		local v;

		if(id == nil)
			id = _currentNode;

		if((v = getVertex(id)) == nil) return(nil);

		id = v.pickTransition();
		_currentNode = id;

		return(_currentNode);
	}
;

class MarkovState: SimpleGraphVertex
	getTransitions() { return(edgeList()); }
	pickTransition() {
		local l, v, w;

		l = getTransitions();
		v = new Vector();
		w = new Vector();
		l.forEach(function(o) {
			v.append(o._vertex1.id);
			w.append(o.getWeight());
		});
		return(randomElementWeighted(v, w, _prng));
	}
;

class MarkovTransition: SimpleGraphEdge
	getWeight() { return(getLength()); }
	setWeight(v) { return(setLength(v)); }
;
