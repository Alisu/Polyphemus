writing
divorceStackOf: aProcess

	"The frames of this process, oldest first, each becoming the sender of the one above it.
	The process then suspends in the newest of them."

	| activations frames sender |
	activations := [ self reified activationsOfProcess: aProcess ]
		               on: Error
		               do: [ :e | #(  ) ].
	frames := activations select: [ :each | each isStackFrame ].
	frames ifEmpty: [ ^ 0 ].
	sender := (activations allButFirst: frames size)
		          ifEmpty: [ dumped memory nilObject ]
		          ifNotEmpty: [ :contexts | contexts first address ].
	frames reverseDo: [ :frame | sender := self contextFor: frame sender: sender ].
	dumped memory
		storePointerUnchecked: 1
		ofObject: aProcess address
		withValue: sender.
	^ frames size
