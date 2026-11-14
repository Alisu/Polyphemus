contexts
contextInconsistencies

	"What a snapshot's stacks cannot show if a working VM wrote it: offending context -> what is
	wrong. The queues are #processInconsistencies' question."

	| problems nilObject |
	problems := OrderedCollection new.
	nilObject := memory reifiedNilObject.

	memory allReifiedProcesses do: [ :process |
		| stack last sender |
		stack := self contextsOfProcess: process.
		stack ifNotEmpty: [
			last := stack last.
			sender := [ self senderOf: last ] on: PolyphemusError do: [ :e | nil ].
			sender ifNil: [ problems add: last -> #senderIsUnreadable ].
			(sender isNil or: [ sender = nilObject ]) ifFalse: [
				(stack includes: sender)
					ifTrue: [ problems add: last -> #stackIsCircular ]
					ifFalse: [ problems add: last -> #senderIsNotAContext ] ] ].
		stack do: [ :context |
			([ | method |
			   method := context reifiedSlotAt: self contextMethodSlot.
			   method isCompiledMethodOop or: [ method isCompiledBlockOop ] ]
				on: PolyphemusError do: [ :e | false ]) ifFalse: [
				problems add: context -> #methodIsNotCompiledCode ] ] ].

	^ problems
