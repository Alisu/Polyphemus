highlighting
sourceNodeExecutedBy: anActivation

	"The piece of source an activation is in, as a syntax tree node, or nil when its code
	could not be reproduced faithfully enough to say."

	| code |
	code := self faithfulCodeOf: anActivation.
	code ifNil: [ ^ nil ].
	^ [ code sourceNodeForPC: anActivation executedPC ] on: Error do: [ :e | nil ]
