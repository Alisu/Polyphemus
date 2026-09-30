helpers
categoriesOf: aPainter upTo: aPixel

	^ (0 to: aPixel) collect: [ :each | aPainter categoryOfPixel: each ]
