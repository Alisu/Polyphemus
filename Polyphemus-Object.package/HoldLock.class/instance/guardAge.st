accessing
guardAge

	"How old a guard is before it is taken for one left by an observer that died taking the lock."

	^ guardAge ifNil: [ 10 seconds ]
