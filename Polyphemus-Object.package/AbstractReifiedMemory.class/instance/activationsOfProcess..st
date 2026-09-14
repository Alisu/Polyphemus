contexts
activationsOfProcess: aProcessOop

	"The stack of a process, top first, whichever form each activation is in.

	A running VM keeps the newest activations as frames on a stack page and the older ones
	as contexts in the heap, and one stack runs through both. The frames come first, oldest
	last on their page, and that oldest one says which context called into the page. From
	there it is contexts to the bottom, which is what stage one already walks.

	A process whose context was never married has no frames at all, and this answers the
	same thing #contextsOfProcess: does."

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
