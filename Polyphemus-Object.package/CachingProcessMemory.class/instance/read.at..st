reading
read: aCount at: anAddress

	"aCount bytes straight from the process, or nil unless all of them were read."

	^ self subclassResponsibility
