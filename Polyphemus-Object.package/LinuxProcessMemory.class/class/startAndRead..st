instance creation
startAndRead: aCommand

	"Start a process from here and answer a reader for it.

	Be warned that this does *not* get round Yama on a machine where `ptrace_scope` is 1.
	`LibC` can only run a command through a shell, and a command put in the background with
	`&` outgrows us the moment that shell exits: the child is reparented to init, we stop
	being its ancestor, and the kernel refuses us its memory. Measured, not assumed -- a
	`sleep` started this way is unreadable a moment later.

	Keeping a child a child needs a real fork and exec, which means OSSubprocess or a
	foreign call, and neither is here. So on such a machine this ends in the refusal that
	says so, which is the honest answer; where `ptrace_scope` is 0 it simply works.

	Reading is the part that needs nothing: see the class comment."

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
