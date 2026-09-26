holding
checkItsVersion

	| major |
	major := (process ask: 'SystemVersion current major') asNumber.
	(PolyphemusEdition current refusalOfTarget: major) ifNotNil: [ :refusal |
		self letGo.
		self error: refusal ]
