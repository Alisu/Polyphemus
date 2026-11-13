private
textIn: someBytes

	"The C string in someBytes, up to its first NUL; bytes that are no text are refused by name."

	^ [ (someBytes asByteArray copyUpTo: 0) utf8Decoded ]
		  on: ZnCharacterEncodingError
		  do: [ :error | self refuse: #itsVariableHoldsNoText ]
