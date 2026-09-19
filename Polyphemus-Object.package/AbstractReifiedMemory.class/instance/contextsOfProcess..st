contexts
contextsOfProcess: aProcessOop

	"The stack of a process, top first, as contexts. Stops at nil, a non-context, a loop or
	an unreadable slot, rather than raising."

	| contexts seen current nilObject |
	contexts := OrderedCollection new.
	seen := Set new.
	nilObject := self reifiedNilObject.
	current := self
		           readSlot: self processSuspendedContextSlot
		           of: aProcessOop
		           ifUnreadable: [ nilObject ].
	[ current = nilObject
		or: [ (seen includes: current)
		or: [ ([ current isContextOop ] on: Error do: [ :e | false ]) not ] ] ] whileFalse: [
		seen add: current.
		contexts add: current.
		current := [ self senderOf: current ] on: Error do: [ :e | nilObject ] ].
	^ contexts
