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
		_checkWeights(obj);
	}
	_checkWeights(obj) {
		local b, t;

		obj.vertexList().forEach(function(v) {
			t = new BigNumber(0);
			b = nil;
			v.edgeList.forEach(function(e) {
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
;

#endif // __DEBUG
#endif // LINTER
