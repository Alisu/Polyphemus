evaluating
evaluate

	"In the frame of the image held when there is one; else in the observer, as Pharo would, which
	is said (#126)."

	| compiler |
	(requestor session evaluate: (source isString ifTrue: [ source ] ifFalse: [ source contents ]) in: context)
		ifNotNil: [ :evaluation | ^ evaluation ].
	compiler := context receiver class compiler.
	settings do: [ :each | each sendTo: compiler ].
	compiler receiver: context receiver.
	^ [ ObserverEvaluation of: compiler evaluate ] ensure: [ requestor sayCodeRunsInTheObserver ]
