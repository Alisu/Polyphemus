young objects
youngSpaceStart

	"Where new space's objects begin: where the VM says its live young objects are, or else
	found by shape -- our geometry for the memory manager is not the VM's, so only objects
	that walk can be trusted."

	^ youngStart ifNil: [
		  youngStart := self liveYoungRanges
			                ifNotNil: [ :ranges | (ranges collect: [ :each | each key ]) min ]
			                ifNil: [
				                self scanner
					                firstObjectRunFrom: self newSpaceStart
					                upTo: self newSpaceLimit
					                atLeast: 50 ] ]
