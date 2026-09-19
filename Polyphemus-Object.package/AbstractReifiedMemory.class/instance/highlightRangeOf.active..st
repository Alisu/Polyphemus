highlighting
highlightRangeOf: anActivation active: contextIsActive

	"Where in the source the activation is, as an interval. Activations below the top are
	read at pc - 1, Pharo's own rule. Empty when the code cannot be reproduced."

	| code thePC |
	code := self faithfulCodeOf: anActivation.
	code ifNil: [ ^ 1 to: 0 ].

	thePC := ([ anActivation isDead ] on: Error do: [ :e | false ])
		         ifTrue: [ [ code endPC ] on: Error do: [ :e | anActivation pc ] ]
		         ifFalse: [ anActivation pc ].
	thePC ifNil: [ ^ 1 to: 0 ].
	contextIsActive ifFalse: [ thePC := thePC - 1 ].

	^ [ code rangeForPC: thePC ] on: Error do: [ :e | 1 to: 0 ]
