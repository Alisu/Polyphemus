checking
checkClasses

	"Fails only on structural damage to the class table. A bad entry just loses that class's
	name; see SpurDumpedMemory>>unreadableClassIndexes."

	| problems |
	problems := dumped classTableStructureProblems.
	^ problems ifEmpty: [ nil ] ifNotEmpty: [ problems first key ]
