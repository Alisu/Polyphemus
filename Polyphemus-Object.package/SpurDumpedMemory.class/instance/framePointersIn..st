frames
framePointersIn: aReifiedMemory

	"Frame pointers found from the married contexts of aReifiedMemory, kept only when the
	frame's context slot points back at that context."

	| found |
	found := OrderedCollection new.
	aReifiedMemory do: [ :each |
		[
		| sender fp |
		sender := aReifiedMemory simulator fetchPointer: 0 ofObject: each address.
		(sender > 0 and: [
			 sender < mappingStart or: [ sender >= mappingLimit ] ]) ifTrue: [
			fp := sender - 1.
			(self spaceHolding: fp) ifNotNil: [
				(self wordOfFrame: fp at: -16) = each address ifTrue: [ found add: fp ] ] ] ]
			on: Error
			do: [ :e | nil ] ].
	^ found
