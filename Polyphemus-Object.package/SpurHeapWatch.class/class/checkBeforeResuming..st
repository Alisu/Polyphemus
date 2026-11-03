watching
checkBeforeResuming: aProcessMemory

	"A process written while stopped is checked before it runs again: running, its heap moves, and
	the test may end it (#141)."

	current ifNotNil: [ :watch | watch checkBeforeResuming: aProcessMemory ]
