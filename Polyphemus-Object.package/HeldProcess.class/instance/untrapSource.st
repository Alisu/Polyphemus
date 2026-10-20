private
untrapSource

	"For a process caught by runUntil:'s trap, running the twin Reflectivity compiled with it:
	that frame rewound to the method itself (nothing of its body ran, the trap is before it),
	returning where the method was called from, past the reflective method calling the twin (#94)."

	^ '(start method ~~ method and: [ start method selector == method selector ]) ifTrue: [
	| caller |
	caller := start sender.
	[ caller notNil and: [ caller method methodClass == (Smalltalk globals at: #ReflectiveMethod ifAbsent: [ nil ]) ] ]
		whileTrue: [ caller := caller sender ].
	(self at: #session) rewindContextToMethod: method fromContext: start.
	start privSender: caller.
	(self at: #session) updateContextTo: start ].
'
