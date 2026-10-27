contexts
framesOfProcessWithoutContext: aProcessOop

	"Only the process that was running has frames but no context."

	([ aProcessOop address = memory reifiedActiveProcess address ] on: Error do: [ :e | false ])
		ifFalse: [ ^ #(  ) ].
	^ [ memory vmLayout framesOfActiveProcess ] on: Error do: [ :e | #(  ) ]
