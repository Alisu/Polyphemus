frames
framePointersIn: aReifiedMemory

	"Frame pointers found from the married contexts of aReifiedMemory, kept only when the
	frame's context slot points back at that context. Only contexts are asked."

	| found simulator |
	found := OrderedCollection new.
	simulator := aReifiedMemory simulator.
	aReifiedMemory do: [ :each |
		([ simulator isContext: each address ] on: Error do: [ :e | false ]) ifTrue: [
			| sender fp |
			sender := simulator fetchPointer: 0 ofObject: each address.
			((simulator isIntegerObject: sender) and: [
				 sender < mappingStart or: [ sender >= mappingLimit ] ]) ifTrue: [
				fp := sender - 1.
				(self spaceHolding: fp) ifNotNil: [
					(self wordOfFrame: fp at: -16) = each address ifTrue: [ found add: fp ] ] ] ] ].
	^ found
