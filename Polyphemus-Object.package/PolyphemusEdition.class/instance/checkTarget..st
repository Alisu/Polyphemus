checking
checkTarget: aMajor

	(self refusalOfTarget: aMajor) ifNotNil: [ :refusal | self error: refusal ]
