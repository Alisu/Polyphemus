contexts
disassemblyOfContext: anActivation

	"The bytecodes a frame or a context runs, one per line, its block's own in a block: what it can
	always show when the source is missing; where they do not read, a line saying why."

	^ String streamContents: [ :stream |
		  [
		  | code |
		  code := anActivation compiledCode.
		  (code notNil and: [ code isCompiledMethodOop or: [ code isCompiledBlockOop ] ]) ifFalse: [
			  NotInTheReading signal: 'what this activation runs is no compiled code: '
				  , (code ifNil: [ 'nil' ] ifNotNil: [ code whatItReadsAs ]) ].
		  code allSymbolicBytecodes do: [ :each |
			  stream
				  nextPutAll: each printString;
				  cr ] ]
			  on: PolyphemusError
			  do: [ :e |
				  stream nextPutAll: 'bytecodes unreadable: '.
				  stream nextPutAll: e messageText asString ] ]
