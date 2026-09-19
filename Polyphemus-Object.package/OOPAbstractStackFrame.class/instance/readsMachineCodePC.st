testing
readsMachineCodePC

	^ [ self layout readsMachineCodePCs ] on: Error do: [ :e | false ]
