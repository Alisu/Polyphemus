classVariables
oopAllClassVariablesNames

	^ self oopClassPoolEntries collect: [ :o | (memory mode nameForClassVariable: o) asString ]
