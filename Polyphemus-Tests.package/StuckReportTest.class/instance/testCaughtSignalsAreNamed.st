tests
testCaughtSignalsAreNamed

	"SigCgt as an idle Pharo VM showed it: a bit for each signal, from bit 0 for signal 1."

	| names |
	names := StuckReport signalNamesIn: 16r1500066FD.

	self assert: (names includesAll: #( 'SIGHUP' 'SIGSEGV' 'SIGUSR1' 'SIGALRM' 'SIGTERM' 'SIGIO' )).
	self deny: (names includes: 'SIGINT')
