contexts
stackFrom: anActivation ofSize: anInteger

	"An activation and everything that called it, top first, in whichever form each one is
	in: frames while there are frames, then contexts.

	Stops on an activation already seen. A working VM does not build a loop; this reads
	images that may not have been written by one."

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
