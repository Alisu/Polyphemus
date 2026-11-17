reading the map
writableSegments

	"The readable regions it may also write: what can change while it runs (#85)."

	^ (((self pathFor: 'maps') asFileReference contents lines
		   select: [ :line |
			   | parts |
			   parts := line substrings: ' '.
			   parts size >= 2 and: [ (parts at: 2) size >= 2 and: [ ((parts at: 2) at: 2) = $w ] ] ])
		  collect: [ :line | self segmentFrom: line ]) reject: [ :each | each isNil ]
