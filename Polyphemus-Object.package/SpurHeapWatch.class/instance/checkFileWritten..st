checking
checkFileWritten: aFileReference

	| file heap |
	file := SpurImageFile on: aFileReference.
	[
	heap := SpurRawHeap on: file.
	heaps remove: heap ifAbsent: [ nil ].
	problems addAll: (self class problemsOf: heap) ] ensure: [ file close ]
