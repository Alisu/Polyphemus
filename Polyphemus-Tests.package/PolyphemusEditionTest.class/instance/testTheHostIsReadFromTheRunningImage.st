tests
testTheHostIsReadFromTheRunningImage

	| host |
	host := PolyphemusHost current.
	self assert: host pharo equals: SystemVersion current major.
	self assert: (#( 'Linux' 'MacOS' 'Windows' ) includes: host os).
	self assert: (#( 'x64' 'arm64' ) includes: host cpu)
