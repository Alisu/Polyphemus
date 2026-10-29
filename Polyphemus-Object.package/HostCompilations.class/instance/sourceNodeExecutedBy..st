highlighting
sourceNodeExecutedBy: anActivation

	"The piece of source an activation is in, read through the tree its code was compiled from, as
	the highlight is: a DoIt's code would parse its source again as a method. Else unknown."

	| code |
	code := self faithfulCodeOf: anActivation.
	code ifNil: [ ^ OOPUnknownSourceNode new ].
	^ [ (self nodeOf: code in: (self hostTreeOf: anActivation)) sourceNodeForPC: anActivation executedPC ]
		  on: memory class syntaxErrors
		  do: [ :e | OOPUnknownSourceNode new ]
