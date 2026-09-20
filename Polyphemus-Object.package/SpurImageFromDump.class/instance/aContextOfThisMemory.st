writing
aContextOfThisMemory

	"A context already in this memory, whose header says what a context's looks like here."

	^ contextLikeness ifNil: [
		  contextLikeness := (self reified allReifiedProcesses
			                      inject: OrderedCollection new
			                      into: [ :all :process |
			                      all
				                      addAll: ([ self reified contextsOfProcess: process ]
						                       on: Error
						                       do: [ :e | #(  ) ]);
				                      yourself ]) first address ]
