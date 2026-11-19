accessing
bytes

	"The bytes of everything counted."

	^ sizes inject: 0 into: [ :sum :each | sum + each ]
