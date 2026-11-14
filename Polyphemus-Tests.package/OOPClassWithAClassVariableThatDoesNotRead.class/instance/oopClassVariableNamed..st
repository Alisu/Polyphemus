accessing
oopClassVariableNamed: aName

	self failIfIn: #oopClassVariableNamed:.
	^ NotInTheReading signal: 'its value points nowhere'
