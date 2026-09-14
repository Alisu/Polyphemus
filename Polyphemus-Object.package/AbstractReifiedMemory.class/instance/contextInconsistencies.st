contexts
contextInconsistencies

	"What the stacks of a snapshot cannot show if the image was written by a working
	VM, as associations from the offending context to what is wrong.

	Kept apart from #processInconsistencies because the two answer different
	questions: one is about the queues, this one about the stacks hanging off them."

	| problems nilObject |
	problems := OrderedCollection new.
	nilObject := self reifiedNilObject.

	self allReifiedProcesses do: [ :process |
		| stack last sender |
		stack := self contextsOfProcess: process.
		stack ifNotEmpty: [
			last := stack last.
			sender := self senderOf: last.
			sender = nilObject ifFalse: [
				(stack includes: sender)
					ifTrue: [ problems add: last -> #stackIsCircular ]
					ifFalse: [ problems add: last -> #senderIsNotAContext ] ] ].
		stack do: [ :context |
			([ | method |
			   method := context reifiedSlotAt: self contextMethodSlot.
			   method isCompiledMethodOop or: [ method isCompiledBlockOop ] ]
				on: Error do: [ :e | false ]) ifFalse: [
				problems add: context -> #methodIsNotCompiledCode ] ] ].

	^ problems
