tools
rowOfProcess: aProcess numbered: aNumber in: aReifiedMemory

	| activations ends |
	activations := [ aReifiedMemory activationsOfProcess: aProcess ]
		               on: Error
		               do: [ :e |
			               ends := e messageText asString.
			               #(  ) ].
	ends ifNil: [
		ends := [ aReifiedMemory stacks whyTheStack: activations endsForProcess: aProcess ]
			        on: Error
			        do: [ :e | e messageText asString ] ].
	^ Dictionary new
		  at: 'process' put: aNumber;
		  at: 'address' put: aProcess address;
		  at: 'state' put: (aReifiedMemory processStates at: aProcess ifAbsent: [ #unknown ]) asString;
		  at: 'priority' put: ([ (aProcess reifiedSlotAt: aReifiedMemory processPrioritySlot) asInteger ] on: Error do: [ :e | nil ]);
		  at: 'name' put: (self nameOfProcess: aProcess);
		  at: 'depth' put: activations size;
		  at: 'top' put: (activations ifEmpty: [ nil ] ifNotEmpty: [ activations first printString ]);
		  at: 'ends' put: ends;
		  yourself
