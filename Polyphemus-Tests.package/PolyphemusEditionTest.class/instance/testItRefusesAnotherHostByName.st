tests
testItRefusesAnotherHostByName

	| edition refusal |
	edition := PolyphemusEdition host: (PolyphemusHost pharo: 10 os: 'Linux' cpu: 'x64') targets: #( 10 ).
	refusal := edition refusalOfHost: (PolyphemusHost pharo: 11 os: 'MacOS' cpu: 'arm64').
	self assert: (refusal includesSubstring: 'Polyphemus-Pharo10-Linux-x64-for-Pharo10').
	self assert: (refusal includesSubstring: 'Pharo 11, MacOS, arm64')
