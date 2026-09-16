checking
checkClasses

	| problems |
	problems := dumped classTableProblems.
	^ problems ifEmpty: [ nil ] ifNotEmpty: [ problems first key ]
