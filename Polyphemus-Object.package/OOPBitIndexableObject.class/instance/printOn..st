printing
printOn: aStream
	| className |
	className := self oopClass oopName.
	aStream << 'Instance of ' << className