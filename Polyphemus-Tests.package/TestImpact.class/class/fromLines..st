instance creation
fromLines: someLines

	"Changes as bin/commit-selection.sh lists them: 'Class selector' for a method, 'Class' for a
	class's definition."

	^ self new setLines: someLines
