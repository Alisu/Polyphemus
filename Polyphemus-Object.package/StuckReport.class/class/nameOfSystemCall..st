naming
nameOfSystemCall: aNumber

	"x86-64 Linux numbers of the calls a stuck VM is found in; the rest by number."

	^ ({
		   (0 -> 'read'). (1 -> 'write'). (7 -> 'poll'). (17 -> 'pread64'). (19 -> 'readv').
		   (23 -> 'select'). (34 -> 'pause'). (35 -> 'nanosleep'). (42 -> 'connect').
		   (43 -> 'accept'). (44 -> 'sendto'). (45 -> 'recvfrom'). (61 -> 'wait4').
		   (202 -> 'futex'). (230 -> 'clock_nanosleep'). (232 -> 'epoll_wait'). (247 -> 'waitid').
		   (270 -> 'pselect6'). (271 -> 'ppoll'). (281 -> 'epoll_pwait'). (288 -> 'accept4').
		   (441 -> 'epoll_pwait2') } asDictionary)
		  at: aNumber
		  ifAbsent: [ 'system call ' , aNumber printString ]
