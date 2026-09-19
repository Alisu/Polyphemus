contexts
contextInconsistencies

	"What a snapshot's stacks cannot show if a working VM wrote it: offending context -> what is
	wrong. The queues are #processInconsistencies' question."

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
