naming
signalNamesIn: aMask

	"The signals a mask from /proc/<pid>/status names: bit 0 is signal 1."

	| names |
	names := #( 'SIGHUP' 'SIGINT' 'SIGQUIT' 'SIGILL' 'SIGTRAP' 'SIGABRT' 'SIGBUS' 'SIGFPE' 'SIGKILL'
	            'SIGUSR1' 'SIGSEGV' 'SIGUSR2' 'SIGPIPE' 'SIGALRM' 'SIGTERM' 'SIGSTKFLT' 'SIGCHLD'
	            'SIGCONT' 'SIGSTOP' 'SIGTSTP' 'SIGTTIN' 'SIGTTOU' 'SIGURG' 'SIGXCPU' 'SIGXFSZ'
	            'SIGVTALRM' 'SIGPROF' 'SIGWINCH' 'SIGIO' 'SIGPWR' 'SIGSYS' ).
	^ (0 to: 63) select: [ :bit | (aMask bitAt: bit + 1) = 1 ] thenCollect: [ :bit |
		  bit < names size
			  ifTrue: [ names at: bit + 1 ]
			  ifFalse: [ 'SIGRT' , (bit + 1) printString ] ]
