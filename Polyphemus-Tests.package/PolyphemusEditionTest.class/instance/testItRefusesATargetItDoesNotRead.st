tests
testItRefusesATargetItDoesNotRead

	| edition |
	edition := PolyphemusEdition host: (PolyphemusHost pharo: 10 os: 'Linux' cpu: 'x64') targets: #( 10 ).
	self assert: (edition refusalOfTarget: 10) isNil.
	self assert: ((edition refusalOfTarget: 12) includesSubstring: 'Pharo 12')
