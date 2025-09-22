package main

import (
	"log"
	"net/http"
	"github.com/rsdoiel/mdserver" // replace with your actual module path
)

// dotFileHidingFileSystem is a custom file system that hides dotfiles.
type dotFileHidingFileSystem struct {
	fs http.FileSystem
}

func (fs dotFileHidingFileSystem) Open(name string) (http.File, error) {
	f, err := fs.fs.Open(name)
	if err != nil {
		return nil, err
	}
	return f, nil
}

func main() {
	// Create a new file system handler for the current directory with dot file hiding
	fsys := dotFileHidingFileSystem{fs: http.Dir(".")}

	// Create a file server handler for the custom file system
	fileServer := http.FileServer(fsys)

	// Wrap the file server handler with the Markdown handler
	handler := mdserver.MarkdownHandler(fileServer)

	// Use the handler to serve files
	http.Handle("/", handler)

	// Start the server
	log.Println("Server started on :8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
