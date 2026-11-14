contexts
stackFrom: anActivation ofSize: anInteger

	"An activation and all that called it, top first, frames then contexts. Stops on one already
	seen, and where a sender does not read or is no activation: a damaged image may hold those."

	| activations current seen |
	activations := OrderedCollection new.
	seen := OrderedCollection new.
	current := anActivation.
	[
	current isNil or: [
		(seen includes: current) or: [ activations size >= anInteger ] ] ] whileFalse: [
		seen add: current.
		activations add: current.
		current := [ current sender ] on: PolyphemusError do: [ :e | nil ].
		(current notNil and: [ current isNilOop ]) ifTrue: [ current := nil ] ].
	^ activations
