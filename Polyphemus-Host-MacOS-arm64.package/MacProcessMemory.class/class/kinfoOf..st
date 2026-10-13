reading processes
kinfoOf: aPid

	"The kernel's kinfo_proc of a process (sysctl CTL_KERN, KERN_PROC, KERN_PROC_PID): 648
	bytes on arm64, p_pid at 40 and p_sigcatch at 236 (measured 2026-10-13). No root needed."

	| name buffer size |
	name := self pinned: 16.
	#( 1 14 1 ) doWithIndex: [ :each :index | name signedLongAt: index - 1 * 4 + 1 put: each ].
	name signedLongAt: 13 put: aPid.
	buffer := self pinned: 648.
	size := self pinned: 8.
	size unsignedLongLongAt: 1 put: 648.
	((self sysctl: name length: 4 into: buffer size: size new: ExternalAddress null length: 0) = 0 and: [
		 (size unsignedLongLongAt: 1) = 648 and: [ (buffer signedLongAt: 41) = aPid ] ]) ifFalse: [ ^ nil ].
	^ buffer
