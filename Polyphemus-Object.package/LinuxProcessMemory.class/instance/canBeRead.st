testing
canBeRead

	"Whether the operating system will actually hand over this process's memory. There is no
	asking: the only way to find out is to open it."

	^ [
	  | opened |
	  opened := (self pathFor: 'mem') asFileReference binaryReadStream.
	  opened close.
	  true ] on: Error do: [ :e | false ]
