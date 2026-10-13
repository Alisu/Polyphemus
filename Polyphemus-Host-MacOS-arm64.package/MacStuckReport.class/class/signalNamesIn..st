naming
signalNamesIn: aMask

	"As macOS numbers them (kill -l): bit 0 is signal 1."

	| names |
	names := #( 'SIGHUP' 'SIGINT' 'SIGQUIT' 'SIGILL' 'SIGTRAP' 'SIGABRT' 'SIGEMT' 'SIGFPE' 'SIGKILL'
	            'SIGBUS' 'SIGSEGV' 'SIGSYS' 'SIGPIPE' 'SIGALRM' 'SIGTERM' 'SIGURG' 'SIGSTOP' 'SIGTSTP'
	            'SIGCONT' 'SIGCHLD' 'SIGTTIN' 'SIGTTOU' 'SIGIO' 'SIGXCPU' 'SIGXFSZ' 'SIGVTALRM'
	            'SIGPROF' 'SIGWINCH' 'SIGINFO' 'SIGUSR1' 'SIGUSR2' ).
	^ (1 to: names size) select: [ :bit | (aMask bitAt: bit) = 1 ] thenCollect: [ :bit | names at: bit ]
