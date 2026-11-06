reading
whatItWaitsOnFrom: aTaskDirectory

	"From the call's name and its first argument; the calls that wait on many descriptors at once
	hold them in the process's memory, not in the argument."

	| name |
	name := self systemCallName.
	name = 'futex' ifTrue: [ ^ 'a lock (futex)' ].
	(#( 'wait4' 'waitid' ) includes: name) ifTrue: [ ^ 'a child process' ].
	(#( 'read' 'write' 'pread64' 'readv' 'connect' 'accept' 'accept4' 'sendto' 'recvfrom' 'epoll_wait' 'epoll_pwait' 'epoll_pwait2' )
		 includes: name) ifFalse: [ ^ nil ].
	^ self descriptor: arguments first in: aTaskDirectory
