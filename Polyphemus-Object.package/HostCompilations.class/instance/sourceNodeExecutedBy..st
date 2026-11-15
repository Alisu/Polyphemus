highlighting
sourceNodeExecutedBy: anActivation

	"The piece of source an activation is in, read through the tree its code was compiled from, as
	the highlight is: a DoIt's code would parse its source again as a method. Else unknown."

	| code tree pc |
	code := self faithfulCodeOf: anActivation.
	code ifNil: [ ^ OOPUnknownSourceNode new ].
	tree := (self hostTreeOf: anActivation) ifNil: [ ^ OOPUnknownSourceNode new ].
	pc := [ anActivation executedPC ] on: PolyphemusError do: [ :refusal | ^ OOPUnknownSourceNode new ].
	^ ForeignCode
		  askingPharo: [ (self nodeOf: code in: tree) sourceNodeForPC: pc ]
		  ifItFails: [ OOPUnknownSourceNode new ]
