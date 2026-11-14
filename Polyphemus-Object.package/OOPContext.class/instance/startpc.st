context protocol
startpc

	"Its code's first bytecode, counted as its pc is (#184)."

	^ [ self compiledCode firstActivationPC ] on: PolyphemusError do: [ :e | 1 ]