tests
testItsBuildIdIsItsUUID

	"LC_UUID: sixteen bytes, as otool -l shows them (20D0E187-9EDD-320B-AED5-796800F13394 for
	Pharo 13's VM, 2026-10-13), and each VM build its own (#80)."

	| uuid |
	uuid := self library buildId.
	self assert: uuid size equals: 16.
	self deny: (uuid allSatisfy: [ :each | each = 0 ])
