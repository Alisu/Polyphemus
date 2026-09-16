checking
whyCannotRead: aLevel

	^ self perform: ('check' , aLevel asString capitalized) asSymbol
