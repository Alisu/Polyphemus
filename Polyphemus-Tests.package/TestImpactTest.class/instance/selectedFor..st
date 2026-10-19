helpers
selectedFor: someLines

	"The test classes' names selected for changes given as bin/commit-selection.sh lists them."

	^ ((TestImpact fromLines: someLines) testClasses collect: [ :each | each name ]) asSet
