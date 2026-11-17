accessing
objectCount

	^ counts inject: 0 into: [ :sum :each | sum + each ]
