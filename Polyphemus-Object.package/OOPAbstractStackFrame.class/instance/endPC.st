context protocol
endPC

	"Its code's last bytecode, counted as its pc is (#184)."

	^ [ self compiledCode lastActivationPC ] on: Error do: [ :e | self startpc ]