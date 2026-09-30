painting
add: aCount bytesOf: aCode at: anAddress to: aPixel

	aPixel = openPixel ifFalse: [
		self closeOpenPixel.
		openPixel := aPixel.
		openCounts := Array new: self class categories size withAll: 0.
		openFirsts := Array new: self class categories size ].
	openCounts at: aCode + 1 put: (openCounts at: aCode + 1) + aCount.
	(openFirsts at: aCode + 1) ifNil: [ openFirsts at: aCode + 1 put: anAddress ]
