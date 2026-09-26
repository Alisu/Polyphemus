highlighting
hostMethodOfMethod: aReifiedMethod

	"The method recompiled here against its own class, answered only when its bytecodes equal
	the image's; nil otherwise. For a method alone: hostMethodFor: needs an activation."

	^ (self
		   rememberedAt: 'hostMethodOfMethod.' , aReifiedMethod address printString
		   ifAbsentPut: [
			   ([ aReifiedMethod getSourceFromFile ] on: Error do: [ :e | nil ])
				   ifNil: [ false ]
				   ifNotNil: [ :source |
					   (self compileHostSource: source for: aReifiedMethod oopMethodClass)
						   ifNil: [ false ]
						   ifNotNil: [ :pair |
							   (self host: pair first matchesOop: aReifiedMethod)
								   ifTrue: [ pair first ]
								   ifFalse: [ false ] ] ] ])
		  ifNotNil: [ :cached | cached == false ifTrue: [ nil ] ifFalse: [ cached ] ]
