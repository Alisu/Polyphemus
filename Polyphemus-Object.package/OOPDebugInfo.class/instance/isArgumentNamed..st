testing
isArgumentNamed: aName

	^ (code argumentNames collect: [ :each | each asSymbol ]) includes: aName asSymbol
