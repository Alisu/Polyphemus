writing
writeStream

	"A stream of its own on /proc/<pid>/mem, opened to write. Reading keeps its own: a write
	must not move where a read had got to."

	^ writeStream ifNil: [
		  writeStream := (File named: (self pathFor: 'mem')) writeStream ]
