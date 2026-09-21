accessing
recompileMethodTo: aString inContext: aContext notifying: aNotifier

	"Accepting in the debugger's code pane. The method is in another image, so it is compiled
	here and written there; nothing is rewound, this stack being a reading and not a process
	of ours."

	aContext ifNil: [ ^ false ].
	^ self fixMethodOf: aContext to: aString notifying: aNotifier
