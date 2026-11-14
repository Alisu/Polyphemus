accessing
oopAllClassVariablesNames

	"The name of each class variable; one whose entry does not read keeps its place as
	'(unreadable name)', so the others still pair with their own values."

	^ self oopClassPoolEntries collect: [ :o |
		  [ (memory mode nameForClassVariable: o) asString ]
			  on: PolyphemusError
			  do: [ :unreadable | '(unreadable name)' ] ]
