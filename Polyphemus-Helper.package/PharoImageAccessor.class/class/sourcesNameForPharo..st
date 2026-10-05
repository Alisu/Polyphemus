naming
sourcesNameForPharo: aNumber

	"The name that version's pinned image looks for its sources under, beside itself, as found
	in its download: not derivable from the pin (Pharo 13's says 13.1). nil if not pinned."

	^ {
		  (10 -> 'Pharo10.0-64bit-0542643.sources').
		  (11 -> 'Pharo11.0-64bit-cf3d3fd.sources').
		  (12 -> 'Pharo12.0-64bit-aa50f9c.sources').
		  (13 -> 'Pharo13.1-64bit-d7c6f76.sources').
		  (14 -> 'Pharo14.0-64bit-bf1210a.sources') } asDictionary
		  at: aNumber
		  ifAbsent: [ nil ]
