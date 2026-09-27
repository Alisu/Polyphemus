running
runCaseWithTheUIHeld

	"For tests that open windows and change them from this process: Morphic's UI process would
	draw them meanwhile, and Pharo 12's Roassal loses its damage to that (#56)."

	| ui |
	ui := Process allInstances
		      detect: [ :each | each name = 'Morphic UI Process' and: [ each isTerminated not ] ]
		      ifNone: [ nil ].
	(ui isNil or: [ ui == Processor activeProcess ]) ifTrue: [ ^ super runCase ].
	ui suspend.
	[ super runCase ] ensure: [ ui resume ]
