highlighting
sourceNodeExecutedBy: anActivation

	"The piece of source an activation is in, as a syntax tree node; an OOPUnknownSourceNode
	when its code could not be reproduced faithfully enough to say."

	| code |
	code := self faithfulCodeOf: anActivation.
	code ifNil: [ ^ OOPUnknownSourceNode new ].
	^ [ code sourceNodeForPC: anActivation executedPC ] on: Error do: [ :e | OOPUnknownSourceNode new ]
