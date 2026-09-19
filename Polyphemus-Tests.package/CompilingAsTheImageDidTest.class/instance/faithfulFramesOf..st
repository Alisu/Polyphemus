running
faithfulFramesOf: aMemory

	"How many frames of the memory get code compiled here that is byte-identical to the file's."

	| frames |
	frames := aMemory allReifiedProcesses
		          inject: OrderedCollection new
		          into: [ :all :each |
			          all addAll: ([ aMemory contextsOfProcess: each ] on: Error do: [ :e | #(  ) ]).
			          all ].
	^ (frames select: [ :each |
		   ([ aMemory faithfulCodeOf: each ] on: Error do: [ :e | nil ]) notNil ]) size
