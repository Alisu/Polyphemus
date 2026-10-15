library
suspendProcess: aHandle

	^ self ffiCall: #( int32 NtSuspendProcess ( uint64 aHandle ) ) module: 'ntdll.dll'
