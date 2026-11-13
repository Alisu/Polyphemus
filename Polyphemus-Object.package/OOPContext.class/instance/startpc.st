context protocol
startpc

	"Its code's first bytecode, counted as its pc is (#184)."

	^ [ self compiledCode firstActivationPC ] on: Error do: [ :e | 1 ]