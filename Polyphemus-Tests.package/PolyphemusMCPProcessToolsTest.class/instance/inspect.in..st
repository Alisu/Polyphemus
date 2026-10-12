running
inspect: anAddress in: aHandle

	^ self call: 'inspect' with: (Dictionary new at: 'handle' put: aHandle; at: 'address' put: anAddress; yourself)
