context protocol
selector

	^ [ self homeMethod oopSelector asString asSymbol ]
		  on: Error
		  do: [ :e | #unknownSelector ]
