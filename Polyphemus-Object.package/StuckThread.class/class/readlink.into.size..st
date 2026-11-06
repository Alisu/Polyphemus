private
readlink: aPath into: aBuffer size: aSize

	^ self
		  ffiCall: #( long readlink #( String aPath , void * aBuffer , size_t aSize ) )
		  module: LibC
