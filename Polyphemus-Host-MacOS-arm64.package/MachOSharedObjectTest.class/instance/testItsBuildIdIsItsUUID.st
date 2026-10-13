tests
testItsBuildIdIsItsUUID

	"LC_UUID, as otool -l shows it: 20D0E187-9EDD-320B-AED5-796800F13394."

	self assert: self library buildId hex asUppercase equals: '20D0E1879EDD320BAED5796800F13394'
