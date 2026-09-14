contexts
descriptionOfContext: anActivation

	"One line of a stack, the way a debugger lists it: the class of the receiver and the
	selector being run. A block activation is marked as such and borrows the selector of its
	home method.

	The class named here is the receiver's, not the one implementing the method; telling
	those apart needs the method's class binding resolved, which is its own piece of work.

	Asked of the activation rather than read out of its slots, so that a frame answers it as
	well as a context."

	| method receiverClass selector |
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
