checking
checkHost

	(self refusalOfHost: PolyphemusHost current) ifNotNil: [ :refusal | NotSetUp signal: refusal ]
