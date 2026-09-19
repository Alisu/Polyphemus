contexts
activationsOfProcess: aProcessOop

	"The stack of a process, top first: frames on a stack page, then contexts in the heap.
	The running process has no context; its frames are where the VM saved its registers."

	| activations context frames |
	activations := OrderedCollection new.
	context := self
		           readSlot: self processSuspendedContextSlot
		           of: aProcessOop
		           ifUnreadable: [ nil ].
	context ifNil: [ ^ activations ].

	frames := ([ context isNilOop ] on: Error do: [ :e | false ])
		          ifTrue: [ self framesOfProcessWithoutContext: aProcessOop ]
		          ifFalse: [ self framesFromContext: context ].
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
