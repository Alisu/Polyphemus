writing
threadNotes

	"An NT_PRSTATUS per thread, where the reader gives each thread's full aarch64 registers;
	none otherwise, as Linux's cores from /proc have none."

	(self machine = 183 and: [ memory respondsTo: #threadRegisters ]) ifFalse: [ ^ #[  ] ].
	^ ByteArray streamContents: [ :stream |
		  memory threadRegisters do: [ :each |
			  (each includesKey: #pc) ifTrue: [ stream nextPutAll: (self statusNoteOf: each) ] ] ]
