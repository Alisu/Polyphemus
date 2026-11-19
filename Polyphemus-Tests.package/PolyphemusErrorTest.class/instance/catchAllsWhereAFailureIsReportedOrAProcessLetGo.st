accessing
catchAllsWhereAFailureIsReportedOrAProcessLetGo

	"A report of a failure, a check before a process is let go, the server's last answer: failing
	in its turn would hide the first failure or leave a process held. Each says what it caught."

	^ #( 'BlockClosure>>valueThenLetGo:' 'HeldImage>>whyTheInterruptWasNotTaken' 'HeldProcess>>fix:to:restartingAt:'
	     'PolyphemusMCPServer>>answer:' 'SpurHeapWatch class>>problemsOf:' 'SpurHeapWatch>>wasWritten:at:' )
