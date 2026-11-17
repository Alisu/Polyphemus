tests
testItReadsTheSignalsAProcessCatches

	"p_sigcatch (sysctl KERN_PROC_PID), named as macOS numbers signals: a shell trapping
	SIGUSR2 and ignoring SIGUSR1. No root needed."

	| scratch pidFile pid catches |
	scratch := PolyphemusEdition current scratch.
	pidFile := scratch / 'mac-trapping.pid'.
	pidFile ensureDelete.
	LibC system: 'sh -c ''trap "" USR1; trap ":" USR2; sleep 30; true'' >/dev/null 2>&1 & echo $! > "'
		, pidFile fullName , '"'.
	50 timesRepeat: [ pidFile exists ifFalse: [ (Delay forMilliseconds: 100) wait ] ].
	(Delay forMilliseconds: 500) wait.
	pid := pidFile contents trimBoth asNumber.
	[
	catches := MacStuckReport caughtSignalsOf: pid.
	self assert: (catches includes: 'SIGUSR2').
	self deny: (catches includes: 'SIGUSR1') ] ensure: [ LibC system: 'kill ' , pid printString ]
