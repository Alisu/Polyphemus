contexts
framesOfProcessWithoutContext: aProcessOop

	"Only the process that was running has frames but no context. None where its frames are
	refused: #whyNoActivationOfProcess: says why."

	aProcessOop address = memory reifiedActiveProcess address ifFalse: [ ^ #(  ) ].
	^ [ memory vmLayout framesOfActiveProcess ] on: PolyphemusError do: [ :e | #(  ) ]
