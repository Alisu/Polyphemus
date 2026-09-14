contexts
contextsOfProcess: aProcessOop

	"The stack of a process, top first. A snapshot holds no frames: the VM turned
	them all into contexts before writing the image. The one exception is the running
	process, whose context the simulator marries back to a frame when it loads the
	image, so walking senders goes through #senderOf:.

	The walk stops at nil, at anything that is not a context, and on a context already
	seen. All three can happen in a damaged image, and a stage one walk that loops or
	raises is no use at all. So can a slot that cannot be read at all: that answers no
	stack, rather than a stack invented out of whatever the bad word addresses."

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
