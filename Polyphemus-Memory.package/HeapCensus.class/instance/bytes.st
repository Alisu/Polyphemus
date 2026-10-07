accessing
bytes

	^ sizes inject: 0 into: [ :sum :each | sum + each ]
