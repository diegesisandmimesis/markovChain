#charset "us-ascii"
//
// markovChainLinter.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "markovChain.h"

#ifdef LINTER
#ifdef __DEBUG

#include <bignum.h>

modify MarkovChain
	_markovMatrixLint = nil
	_markovIVLint = nil

	_initializeMarkovMatrix() {
		_markovMatrixLint = _markovMatrix;
		return(inherited());
	}

	_initializeMarkovIV(prng?) {
		_markovIVLint = _markovIV;
		return(inherited(prng));
	}
;

modify MarkovTransition
	_weight = nil

	_fixWeight() {
		_weight = _length;
		inherited();
	}
;

markovChainLinter: Linter;
+LintClass @MarkovChain
	lintAction(obj) {
		_checkDeclaredProbabilities(obj);
		_checkMatrixProbabilities(obj);
		_checkMatrixIV(obj);
	}
	// Check decimal probabilities for transitions declared via the
	// +MarkovTransition [declaration] syntax.
	_checkDeclaredProbabilities(obj) {
		local b, t;

		obj.vertexList().forEach(function(v) {
			t = new BigNumber(0);
			b = nil;
			v.edgeList.forEach(function(e) {
				if(e._weight == nil) return;
				if(!((e._weight > 0) && (e._weight < 1.0)))
					return;
				t += e._weight;
				b = true;
			});
			if(b == nil) return;
			if(t == 1) return;
			warning('Markov chain has a state (<<toString(v.id)>>)
				whose transition probabilities do not
				add up to 1.0 (got
				<<toString(t.roundToDecimal(3))>>)',
				'Decimal weights in a
				MarkovTransition declaration are normally
				treated as decimal probabilities:  0.1 is 10%,
				0.25 is 25%, and so on.  Declared this way,
				the probabilities on a state should add up
				to 1.0, or 100%.  This warning indicates that
				there\'s a state where the probabilities don\'t
				add up.
				<p>
				NOTE:  You CAN ignore this, but the results
				might be counterintuitive.  If you declare
				two transitions with a weight of 0.25 and no
				other transitions on the state, then each
				transition will occur with 50% probability
				(because the total is only 0.5 and 0.25 is
				50% of THAT).');
		});
	}
	// Check decimal probabilities for transitions declared via the
	// _markovMatrix synatx.
	_checkMatrixProbabilities(obj) {
		local i, j, l, v;

		if(obj._markovMatrixLint == nil) return;
		if(obj._markovStateList == nil) {
			warning('Markov matrix declared on chain without
				a state list', 'An matrix is only used
				on MarkovChain declarations that
				also supply a state list, so the
				matrix declaration is uneccessary.');
			return;
		}
		l = obj._markovStateList.length;
		if(obj._markovMatrixLint.length != (l * l)) {
			error('MarkovChain with malformed probability matrix',
				'The length of a _markovMatrix declared on a
				MarkovChain must be exactly the length of
				the state list squared.');
			return;
		}
		v = new Vector(l);
		for(i = 1; i <= l; i++) {
			idx = (i - 1) * l;
			v.setLength(0);
			for(j = 1; j <= l; j++) {
				v.append(obj._markovMatrixLint[idx + j]);
			}
			if(!lintProbabilities(v)) {
				warning('MarkovChain with probability matrix
					containing row that doesn\'t sum to
					1.0', 'If _markovMatrix declaration
					contains decimal probabilities, each
					row in the matrix should sum to 1.0.');
			}
		}
	}

	_checkMatrixIV(obj) {
		if(obj._markovIVLint == nil) return;
		if(obj._markovStateList == nil) {
			warning('Markov IV declared on chain without
				a state list', 'An IV is only used
				on MarkovChain declarations that
				also supply a state list, so the
				IV declaration is uneccessary.');
			return;
		}
		if(obj._markovIVLint.length != obj._markovStateList.length) {
			error('Markov IV length doesn\'t match the state
				list length', 'The IV and state list must
				have the same length.  If you want a
				state to have a zero probability of
				being the initial state use a value
				of zero for its entry in the IV.');
			return;
		}
		if(!lintProbabilities(obj._markovIVLint)) {
			warning('IV probabilities don\'t sum to 1.0',
				'This warning means that the Markov chain IV
				contains decimal probabilities but they don\'t
				add up to 1.0.');
		}
	}

	// Check to see if the array contains decimal probabilities.  If so,
	// return boolean true if they sum to 1.0
	lintProbabilities(v) {
		local b, t;

		if(v == nil) return(nil);
		t = new BigNumber(0);
		b = nil;
		v.forEach(function(o) {
			if((o == nil) || (o < 0) || (o > 1))
				return;
			b = true;
			t += o;
		});

		// If there were no decimal probabilities we automatically
		// pass.
		if(b == nil)
			return(true);

		// There were decimal probabilities, so we see if they sum up
		// to 1.0.
		return(t == new BigNumber(1.0));
	}
;

#endif // __DEBUG
#endif // LINTER
