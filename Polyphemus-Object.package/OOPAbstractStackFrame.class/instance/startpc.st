context protocol
startpc

	"Its code's first bytecode, counted as its pc is (#184); 1 where its code does not read, or
	is a JIT frame's this layout cannot read."

	^ [ (self compiledCode ifNil: [ ^ 1 ]) firstActivationPC ] on: PolyphemusError do: [ :e | 1 ]
