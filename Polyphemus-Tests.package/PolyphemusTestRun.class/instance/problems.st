accessing
problems

	"Each test that failed or raised an error, with what it signalled."

	^ outcomes reject: [ :each | each value isSymbol ]
