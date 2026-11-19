tests
testAThreadsSystemCallFileIsReadInOnePlaceAndAThreadGoneIsOneThatRuns

	"#212: three methods each read /proc/<pid>/task/<tid>/syscall, and took a file that does not
	read (its thread ended) two ways: as running, and as stopped outside a call. One reading, and
	such a thread is one that runs: nothing is known of where it is."

	| task |
	task := (self spikeDirectory / 'task-4242') ensureCreateDirectory.
	(task / 'syscall')
		ensureDelete;
		writeStreamDo: [ :stream | stream nextPutAll: '202 0x7f00 0x80 0x0 0x0 0x0 0x0 0x7ffd10 0x7f2a30'; lf ].
	self assert: (LinuxProcessMemory syscallFieldsIn: task) size equals: 9.
	self assert: (LinuxProcessMemory syscallFieldsIn: task) first equals: '202'.
	self assert: (LinuxProcessMemory syscallFieldsIn: task) last equals: '0x7f2a30'.
	(task / 'syscall')
		ensureDelete;
		ensureCreateFile.
	self assert: (LinuxProcessMemory syscallFieldsIn: task) asArray equals: #( 'running' ).
	(task / 'syscall') ensureDelete.
	self assert: (LinuxProcessMemory syscallFieldsIn: task) asArray equals: #( 'running' )
