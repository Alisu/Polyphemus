helpers
copyOfAHeapBridgedFarAway

	"A held copy of a process whose old space ends in a bridge to a segment the system mapped far
	away, as VM 9 can place the segment it adds after a full collection."

	| near |
	near := ByteArray new: 16r2000.
	near
		replaceFrom: 16r2000 - 15 to: 16r2000 - 8
		with: ((16r7FB741EF6000 - (16r10000000 + 16r2000)) // 8 asByteArrayOfSize: 8) reversed
		startingAt: 1.
	near
		replaceFrom: 16r2000 - 7 to: 16r2000
		with: ((255 bitShift: 56) + (9 bitShift: 24) + 3 asByteArrayOfSize: 8) reversed
		startingAt: 1.
	^ ProcessMemoryCopy of: (RegionsDouble new
			   region: 16r10000000 bytes: near writable: true;
			   region: 16r7FB741EF6000 bytes: (ByteArray new: 16r1000) writable: true;
			   yourself)
