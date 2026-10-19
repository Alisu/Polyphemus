walking
walkFrom: anAddress upTo: aLimit

	"Walk objects from anAddress, counting live objects and free chunks apart and noting the
	special objects array. Gives up after a long run of free chunks."

	^ self walkFrom: anAddress upTo: aLimit atMost: nil
