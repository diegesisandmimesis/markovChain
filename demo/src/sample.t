#charset "us-ascii"
//
// sample.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the markovChain library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f makefile.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

#include "markovChain.h"

versionInfo: GameID
        name = 'markovChain Library Demo Game'
        byline = 'Diegesis & Mimesis'
        desc = 'Demo game for the markovChain library. '
        version = '1.0'
        IFID = '12345'
	showAbout() {
		"This is a simple test game that demonstrates the features
		of the markovChain library.
		<.p>
		Consult the README.txt document distributed with the library
		source for a quick summary of how to use the library in your
		own games.
		<.p>
		The library source is also extensively commented in a way
		intended to make it as readable as possible. ";
	}
;
gameMain: GameMainDef
	initialPlayerChar = me
	inlineCommand(cmd) { "<b>&gt;<<toString(cmd).toUpper()>></b>"; }
	printCommand(cmd) { "<.p>\n\t<<inlineCommand(cmd)>><.p> "; }
;

startRoom: Room 'Void' "This is a featureless void.";
+me: Person;

myChain: MarkovChain @foo;
+foo: MarkovState 'foo';
++MarkovTransition ->bar +0.75;
++MarkovTransition ->baz +0.25;
+bar: MarkovState 'bar';
++MarkovTransition ->foo +300;
++MarkovTransition ->baz +100;
+baz: MarkovState 'baz';
++MarkovTransition ->foo +100;
++MarkovTransition ->bar +100;

DefineSystemAction(Foozle)
	execSystemAction() {
		local id;

		id = myChain.pickTransition();

		"New state is <<toString(id)>>.\n ";
	}
;
VerbRule(Foozle) 'foozle': FoozleAction verbPhrase = 'foozle/foozling';
