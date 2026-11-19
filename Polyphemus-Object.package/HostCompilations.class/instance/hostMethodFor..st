highlighting
hostMethodFor: anActivation

	"The activation's method recompiled here from its source, answered only when the
	bytecodes equal the file's; nil otherwise. Cached per method."

	^ self onceForTheMethodOf: anActivation as: 'hostMethod' do: [ self compileHostMethodFor: anActivation ]
