library
dladdr: anAddress into: aBuffer

	"Dl_info: the file's path at 0, its base at 8, the nearest symbol's name at 16 and address at 24."

	^ self ffiCall: #( int dladdr ( uint64 anAddress , void * aBuffer ) )
