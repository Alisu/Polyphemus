instance creation
startAndRead: aCommand

	"Start aCommand and answer a reader for it. This does not get round ptrace_scope 1: the
	shell exits, the child is reparented, and we are no longer its ancestor."

	| pidFile pid waited bang |
	bang := String with: (Character value: 33).
	pidFile := FileLocator temp
	           / ('polyphemus-' , Time millisecondClockValue printString , '.pid').
	pidFile ensureDelete.
	LibC system: aCommand , ' & echo $' , bang , ' > ' , pidFile fullName.

	waited := 0.
	[ pidFile exists and: [ pidFile contents trimBoth notEmpty ] ] whileFalse: [
		(waited := waited + 1) > 100 ifTrue: [
			^ (CannotReadProcess new pid: 0 reason: #nothingStarted) signal ].
		(Delay forMilliseconds: 50) wait ].
	pid := pidFile contents trimBoth asNumber.
	pidFile ensureDelete.
	^ self waitForVirtualMachineUnder: pid
