private
prctlOption: anOption argument: anArgument

	^ self
		  ffiCall: #( int prctl #( int anOption , long anArgument , long 0 , long 0 ,
		                long 0 ) )
		  module: LibC
