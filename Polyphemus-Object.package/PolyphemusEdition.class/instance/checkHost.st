checking
checkHost

	(self refusalOfHost: PolyphemusHost current) ifNotNil: [ :refusal | self error: refusal ]
