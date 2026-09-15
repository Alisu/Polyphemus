testing
isReadable

	"Objects read from an image are readable; only a frame the JIT compiled is not, and it
	answers otherwise. Here so that anything walking a stack can ask without knowing which
	form it holds."

	^ true
