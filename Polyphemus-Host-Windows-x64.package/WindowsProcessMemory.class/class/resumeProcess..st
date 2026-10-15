library
resumeProcess: aHandle

	^ self ffiCall: #( int32 NtResumeProcess ( uint64 aHandle ) ) module: 'ntdll.dll'
