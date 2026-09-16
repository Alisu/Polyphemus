checking
checkClasses

	"Only structural damage fails this rung.

	A single entry that is not a class does not stop the table being used: it costs the name
	of the classes at that one index, and every other object in the heap still gets its own.
	Refusing to read a million objects because one class went bad would be the wrong trade,
	and damage of that kind is far more likely than a table that has gone entirely.

	Which indexes are anonymous is `SpurDumpedMemory>>unreadableClassIndexes`."

	| problems |
	problems := dumped classTableStructureProblems.
	^ problems ifEmpty: [ nil ] ifNotEmpty: [ problems first key ]
