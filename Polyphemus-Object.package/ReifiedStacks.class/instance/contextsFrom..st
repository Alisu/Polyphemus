contexts
contextsFrom: aContext

	"Senders from this context down, top first, stopping at nil, at anything that is not a
	context, at a sender that does not read and on a context already seen -- all of which a
	damaged image can hold, and #contextInconsistencies says which."

	| contexts seen current nilObject |
	contexts := OrderedCollection new.
	seen := Set new.
	nilObject := memory reifiedNilObject.
	current := aContext.
	[ current isNil
		or: [ current = nilObject
		or: [ (seen includes: current)
		or: [ current isContextOop not ] ] ] ] whileFalse: [
		seen add: current.
		contexts add: current.
		current := [ self senderOf: current ] on: PolyphemusError do: [ :e | nil ] ].
	^ contexts
