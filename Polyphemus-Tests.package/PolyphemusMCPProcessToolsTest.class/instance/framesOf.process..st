running
framesOf: aHandle process: aNumber

	^ ((self call: 'stack' with: (Dictionary new at: 'handle' put: aHandle; at: 'process' put: aNumber; at: 'depth' put: 50; yourself)) at: 'structuredContent') at: 'frames'
