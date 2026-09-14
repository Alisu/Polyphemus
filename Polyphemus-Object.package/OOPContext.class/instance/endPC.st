context protocol
endPC
	^ [ self compiledCode endPC ] on: Error do: [ :e | self startpc ]
