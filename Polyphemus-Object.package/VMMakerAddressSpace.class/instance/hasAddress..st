reading
hasAddress: anAddress

	^ [ manager isValidAddress: anAddress ] on: Error do: [ :e | false ]
