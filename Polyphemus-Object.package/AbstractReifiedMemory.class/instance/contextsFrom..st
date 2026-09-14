contexts
contextsFrom: aContext

	"Senders from this context down, top first, stopping at nil, at anything that is not a
	context, and on a context already seen -- all three of which a damaged image can hold."

	| contexts seen current nilObject |
	contexts := OrderedCollection new.
	seen := Set new.
	nilObject := self reifiedNilObject.
	current := aContext.
	[ current isNil
		or: [ current = nilObject
		or: [ (seen includes: current)
		or: [ ([ current isContextOop ] on: Error do: [ :e | false ]) not ] ] ] ] whileFalse: [
		seen add: current.
		contexts add: current.
		current := [ self senderOf: current ] on: Error do: [ :e | nil ] ].
	^ contexts
