reading
caughtSignalsOf: aPid

	"The signals a process catches, from p_sigcatch in its kinfo_proc; empty when it is gone."

	^ (MacProcessMemory kinfoOf: aPid)
		  ifNil: [ #(  ) ]
		  ifNotNil: [ :kinfo | self signalNamesIn: (kinfo unsignedLongAt: 237) ]
