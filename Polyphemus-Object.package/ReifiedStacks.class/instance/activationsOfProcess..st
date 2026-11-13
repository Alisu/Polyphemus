contexts
activationsOfProcess: aProcessOop

	"The stack of a process, top first: its frames, page by page while a page was called by a
	context married to the page before (#183), then the contexts in the heap."

	| activations context frames seen |
	activations := OrderedCollection new.
	context := memory
		           readSlot: memory processSuspendedContextSlot
		           of: aProcessOop
		           ifUnreadable: [ nil ].
	context ifNil: [ ^ activations ].

	frames := ([ context isNilOop ] on: Error do: [ :e | false ])
		          ifTrue: [ self framesOfProcessWithoutContext: aProcessOop ]
		          ifFalse: [ self framesFromContext: context ].
	(frames isEmpty and: [ (self isMarriedContext: context) not ]) ifTrue: [
		^ activations
			  addAll: (self contextsOfProcess: aProcessOop);
			  yourself ].

	seen := Set new.
	[ frames isEmpty ] whileFalse: [
		activations addAll: frames.
		context := [ frames last oopPageCaller ] on: Error do: [ :e | nil ].
		frames := (context notNil and: [ (seen includes: context) not and: [ self isMarriedContext: context ] ])
			          ifTrue: [ seen add: context. self framesFromContext: context ]
			          ifFalse: [ #(  ) ] ].

	context ifNil: [ ^ activations ].
	^ activations
		  addAll: (self contextsFrom: context);
		  yourself