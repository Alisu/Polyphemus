reading the class table
classTablePageSize

	"Entries per page. A class index is a page number and an offset within it, ten bits
	each -- which is why a page is 1024 and why `setHiddenRootsObj:` checks that the first
	one is exactly that size."

	^ 1024
