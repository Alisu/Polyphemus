accessing
closeWhatItReads

	"Let go of the file or the process a dump's or a process's reading reads from; a reading in
	the simulator holds neither."

	self vmLayout raw ifNotNil: [ :raw | raw space close ]
