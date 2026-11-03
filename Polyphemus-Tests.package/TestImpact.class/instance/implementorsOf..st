private
implementorsOf: aSelector

	"Every implementor in the image, asked once per selector."

	implementors ifNil: [ implementors := Dictionary new ].
	^ implementors at: aSelector ifAbsentPut: [ SystemNavigation default allImplementorsOf: aSelector ]
