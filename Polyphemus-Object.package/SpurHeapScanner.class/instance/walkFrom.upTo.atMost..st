walking
walkFrom: anAddress upTo: aLimit atMost: aCount

	"As walkFrom:upTo:, stopping once aCount live objects are found (#enoughObjects), or at
	the limit when aCount is nil."

	^ self walkFrom: anAddress upTo: aLimit atMost: aCount liveDo: nil
