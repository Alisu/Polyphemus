context protocol
startpc
	^ [ self compiledCode initialPC ] on: Error do: [ :e | 1 ]
