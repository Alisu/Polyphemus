painting
offer: aCode bytes: aCount object: anAddress at: aPixel

	| current |
	current := winners at: aPixel + 1.
	((self rankOf: aCode) > (self rankOf: current) or: [
		 (self rankOf: aCode) = (self rankOf: current) and: [ aCount > (winnerBytes at: aPixel + 1) ] ])
		ifFalse: [ ^ self ].
	winners at: aPixel + 1 put: aCode.
	winnerBytes at: aPixel + 1 put: aCount.
	winnerAddresses at: aPixel + 1 put: anAddress
