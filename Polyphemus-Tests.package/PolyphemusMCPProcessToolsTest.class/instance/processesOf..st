running
processesOf: aHandle

	^ ((self call: 'processes' with: (Dictionary new at: 'handle' put: aHandle; yourself)) at: 'structuredContent') at: 'processes'
