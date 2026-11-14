contexts
contextsOfProcess: aProcessOop

	"The stack of a process, top first, as contexts. Stops at nil, a non-context, a loop or
	an unreadable slot, rather than raising; #contextInconsistencies says which."

	| contexts seen current nilObject |
	contexts := OrderedCollection new.
	seen := Set new.
	nilObject := memory reifiedNilObject.
	current := memory
		           readSlot: memory processSuspendedContextSlot
		           of: aProcessOop
		           ifUnreadable: [ nilObject ].
	[ current = nilObject
		or: [ (seen includes: current)
		or: [ current isContextOop not ] ] ] whileFalse: [
		seen add: current.
		contexts add: current.
		current := [ self senderOf: current ] on: PolyphemusError do: [ :e | nilObject ] ].
	^ contexts
