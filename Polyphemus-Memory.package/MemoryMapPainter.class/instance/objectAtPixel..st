accessing
objectAtPixel: anIndex

	"The address of the first object of the category that shows in that pixel, or nil."

	(anIndex between: 0 and: winners size - 1) ifFalse: [ ^ nil ].
	^ winnerAddresses at: anIndex + 1
