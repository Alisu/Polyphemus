accessing
linesIn: aStateFile

	"What a helper wrote there; none while the file cannot be read, as when it fails to open and
	exists a moment later, which Pharo raises as another error than a missing file."

	^ [ aStateFile contents lines ] on: FileException do: [ :error | #(  ) ]
