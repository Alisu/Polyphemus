variables
acceptableLayout

	"Layouts that hold no named instance variables, so there is nothing to look up in
	them. From the hackDebugger branch."

	^ #( 'ByteLayout' 'DoubleByteLayout' 'CompiledMethodLayout' 'ImmediateLayout'
	     'WordLayout' 'DoubleWordLayout' )
