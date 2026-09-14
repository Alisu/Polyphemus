highlighting
sourceNodeExecuted

	"The piece of source this frame is in, as a syntax tree node, or nil when the code
	could not be reproduced faithfully enough to say."

	| code |
	code := self faithfulCompiledCode.
	code ifNil: [ ^ nil ].
	^ [ code sourceNodeForPC: self executedPC ] on: Error do: [ :e | nil ]
