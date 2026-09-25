private
forget: someNames

	"Files the watcher and the trap leave, from a last time, gone before this one."

	someNames do: [ :each | (directory / each) ensureDelete ]
