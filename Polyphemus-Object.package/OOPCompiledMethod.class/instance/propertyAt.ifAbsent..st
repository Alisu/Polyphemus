debugger protocol
propertyAt: aKey ifAbsent: aBlock

	| propertiesOrSelector |
	^ (propertiesOrSelector := self penultimateLiteral) isMethodProperties
		  ifTrue: [ propertiesOrSelector propertyAt: aKey ifAbsent: aBlock ]
		  ifFalse: [ aBlock value ]
