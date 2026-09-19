reading the map
segments

	"Every readable region, read once from /proc/<pid>/maps, without [vvar] and [vsyscall]:
	they look readable but refuse, and would read as damage."

	^ segments ifNil: [
		  segments := ((self pathFor: 'maps') asFileReference contents lines
			               collect: [ :line | self segmentFrom: line ])
			              reject: [ :each | each isNil ] ]
