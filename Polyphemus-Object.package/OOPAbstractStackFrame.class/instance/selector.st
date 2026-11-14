context protocol
selector

	^ [ self homeMethod oopSelector asString asSymbol ]
		  on: PolyphemusError
		  do: [ :e | #unknownSelector ]
