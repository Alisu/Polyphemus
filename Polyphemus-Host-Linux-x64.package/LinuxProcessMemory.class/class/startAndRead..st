instance creation
startAndRead: aCommand

	"Start aCommand and answer a reader for it. This does not get round ptrace_scope 1: the
	shell exits, the child is reparented, and we are no longer its ancestor."

	| pidFile pid bang |
	bang := String with: (Character value: 33).
	pidFile := FileLocator temp
	           / ('polyphemus-' , Time millisecondClockValue printString , '.pid').
	pidFile ensureDelete.
	LibC system: aCommand , ' & echo $' , bang , ' > ' , pidFile fullName.

	(Poll until: [ pidFile exists and: [ pidFile contents trimBoth notEmpty ] ] every: 50 milliSeconds atMost: 100)
		ifFalse: [ ^ (CannotReadProcess new pid: 0 reason: #nothingStarted) signal ].
	pid := pidFile contents trimBoth asNumber.
	pidFile ensureDelete.
	^ self waitForVirtualMachineUnder: pid
