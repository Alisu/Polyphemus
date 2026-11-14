contexts
descriptionOfContext: anActivation

	"One stack line: the receiver's class and the selector, marked for blocks. A JIT frame
	says so instead of being misread, and what does not read of it says so in its place."

	| method receiverClass selector |
	anActivation isReadable ifFalse: [ ^ 'a machine code frame, which is not read yet' ].

	method := [ anActivation compiledCode ] on: PolyphemusError do: [ :e | nil ].
	receiverClass := [ anActivation receiver oopClassName ]
		                 on: PolyphemusError
		                 do: [ :e | 'an unreadable object' ].
	selector := [ (self homeMethodOf: method) oopSelector asString ]
		            on: PolyphemusError
		            do: [ :e | 'an unreadable selector' ].
	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: receiverClass;
			  nextPutAll: '>>';
			  nextPutAll: selector.
		  (method notNil and: [ method isCompiledBlockOop ]) ifTrue: [ stream nextPutAll: ' [block]' ] ]
