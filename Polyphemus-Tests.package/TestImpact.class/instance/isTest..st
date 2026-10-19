testing
isTest: aMethod

	^ (aMethod methodClass inheritsFrom: TestCase) and: [
		  aMethod numArgs = 0 and: [ aMethod selector beginsWith: 'test' ] ]
