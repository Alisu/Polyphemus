dumping
fileNote

	"An NT_FILE note, as the kernel and gdb write one: the files mapped into the process, where
	a reader finds the VM's library, and through it the VM's variables (#66)."

	| files description |
	files := self mappedFiles.
	description := ByteArray streamContents: [ :stream |
		               self write: files size bytes: 8 on: stream.
		               self write: 4096 bytes: 8 on: stream.
		               files do: [ :each |
			               self write: each start bytes: 8 on: stream.
			               self write: each stop bytes: 8 on: stream.
			               self write: each fileOffset // 4096 bytes: 8 on: stream ].
		               files do: [ :each |
			               stream nextPutAll: each path asByteArray.
			               stream nextPut: 0 ] ].
	^ ByteArray streamContents: [ :stream |
		  self write: 5 bytes: 4 on: stream.
		  self write: description size bytes: 4 on: stream.
		  self write: 16r46494C45 bytes: 4 on: stream.
		  stream nextPutAll: 'CORE' asByteArray; nextPutAll: #[ 0 0 0 0 ].
		  stream nextPutAll: description.
		  4 - (description size \\ 4) \\ 4 timesRepeat: [ stream nextPut: 0 ] ]
