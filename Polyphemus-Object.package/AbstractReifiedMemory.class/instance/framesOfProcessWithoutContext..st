contexts
framesOfProcessWithoutContext: aProcessOop

	"Only the process that was running has frames but no context."

	([ aProcessOop address = self reifiedActiveProcess address ] on: Error do: [ :e | false ])
		ifFalse: [ ^ #(  ) ].
	^ [ self vmLayout framesOfActiveProcess ] on: Error do: [ :e | #(  ) ]
