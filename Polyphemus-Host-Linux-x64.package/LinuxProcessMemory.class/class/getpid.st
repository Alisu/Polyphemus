private
getpid

	^ self ffiCall: #( int getpid ( ) ) module: LibC
