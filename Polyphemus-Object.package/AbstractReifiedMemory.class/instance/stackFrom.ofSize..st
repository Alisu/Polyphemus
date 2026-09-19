contexts
stackFrom: anActivation ofSize: anInteger

	"An activation and all that called it, top first, frames then contexts. Stops on one already
	seen: a damaged image may hold a loop a working VM never builds."

	| activations current seen |
	activations := OrderedCollection new.
	seen := OrderedCollection new.
	current := anActivation.
	[
	current isNil or: [
		(seen includes: current) or: [ activations size >= anInteger ] ] ] whileFalse: [
		seen add: current.
		activations add: current.
		current := [ current sender ] on: Error do: [ :e | nil ].
		(current notNil and: [ [ current isNilOop ] on: Error do: [ :e | false ] ])
			ifTrue: [ current := nil ] ].
	^ activations
