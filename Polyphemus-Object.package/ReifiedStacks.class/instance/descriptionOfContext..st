contexts
descriptionOfContext: anActivation

	"One stack line: the receiver's class and the selector, marked for blocks. A JIT frame
	says so instead of being misread."

	| method receiverClass selector |
	([ anActivation isReadable not ] on: Error do: [ :e | false ]) ifTrue: [
		^ 'a machine code frame, which is not read yet' ].

	method := [ anActivation compiledCode ] on: Error do: [ :e | nil ].
	receiverClass := [ anActivation receiver oopClassName ]
		                 on: Error
		                 do: [ :e | 'an unreadable object' ].
	selector := [ (self homeMethodOf: method) oopSelector asString ]
		            on: Error
		            do: [ :e | 'an unreadable selector' ].
	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: receiverClass;
			  nextPutAll: '>>';
			  nextPutAll: selector.
		  ([ method isCompiledBlockOop ] on: Error do: [ :e | false ]) ifTrue: [
			  stream nextPutAll: ' [block]' ] ]
