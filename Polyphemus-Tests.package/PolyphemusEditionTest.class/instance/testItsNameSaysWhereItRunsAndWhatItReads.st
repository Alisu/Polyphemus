tests
testItsNameSaysWhereItRunsAndWhatItReads

	"The name is made from what the edition checks, so the two cannot drift apart."

	self
		assert: (PolyphemusEdition
				 host: (PolyphemusHost pharo: 11 os: 'Linux' cpu: 'x64')
				 targets: #( 10 11 )) name
		equals: 'Polyphemus-Pharo11-Linux-x64-for-Pharo10-11'
