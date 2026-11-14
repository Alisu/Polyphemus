context protocol
endPC

	"Its code's last bytecode, counted as its pc is (#184); where its code does not read, or is
	a JIT frame's this layout cannot read, where it starts."

	^ [ (self compiledCode ifNil: [ ^ self startpc ]) lastActivationPC ]
		  on: PolyphemusError
		  do: [ :e | self startpc ]
