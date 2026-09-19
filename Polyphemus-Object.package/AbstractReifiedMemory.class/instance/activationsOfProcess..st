contexts
activationsOfProcess: aProcessOop

	"The stack of a process, top first: frames on a stack page, then contexts in the heap.
	Without frames, the same as #contextsOfProcess:."

	| activations context frames |
	activations := OrderedCollection new.
	context := self
		           readSlot: self processSuspendedContextSlot
		           of: aProcessOop
		           ifUnreadable: [ nil ].
	context ifNil: [ ^ activations ].

	frames := self framesFromContext: context.
	activations addAll: frames.
	frames ifNotEmpty: [
		context := [ frames last oopPageCaller ]
			           on: Error
			           do: [ :e | nil ] ].

	context ifNil: [ ^ activations ].
	(frames isEmpty and: [ (self isMarriedContext: context) not ]) ifTrue: [
		^ activations
			  addAll: (self contextsOfProcess: aProcessOop);
			  yourself ].

	^ activations
		  addAll: (self contextsFrom: context);
		  yourself
