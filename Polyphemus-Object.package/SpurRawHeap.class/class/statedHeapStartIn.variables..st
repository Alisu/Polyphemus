instance creation
statedHeapStartIn: aSpace variables: someVMVariables

	"Where aSpace says old space starts -- an image file's header -- or else where its VM
	does, in nilObj. nil when neither can be read."

	aSpace oldBaseAddress ifNotNil: [ :start | ^ start ].
	^ [ someVMVariables at: 'nilObj' ] on: Error do: [ :e | nil ]
