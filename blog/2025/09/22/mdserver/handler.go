package mdserver

import (
	"net/http"
	"net/http/httptest"
	"path/filepath"
)

// MarkdownHandler wraps an http.Handler to serve Markdown files as HTML.
func MarkdownHandler(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Check if the requested file has a .md extension
		if filepath.Ext(r.URL.Path) == ".md" {
			// Create a response recorder to capture the response from the next handler
			rr := httptest.NewRecorder()

			// Serve the request using the next handler
			next.ServeHTTP(rr, r)

			// Check if the response status is OK (file found)
			if rr.Code == http.StatusOK {
				// Get the response body
				body := rr.Body.Bytes()

				// Convert Markdown to HTML
				htmlContent, err := MarkdownToHTML(body)
				if err != nil {
					http.Error(w, err.Error(), http.StatusInternalServerError)
					return
				}

				// Set the content type to HTML
				w.Header().Set("Content-Type", "text/html; charset=utf-8")

				// Write the HTML content to the response
				w.Write(htmlContent)
				return
			}

			// If the file wasn't found or there was an error, return the original response
			for k, v := range rr.Header() {
				w.Header()[k] = v
			}
			w.WriteHeader(rr.Code)
			w.Write(rr.Body.Bytes())
			return
		}

		// If not a Markdown file, serve using the next handler directly
		next.ServeHTTP(w, r)
	})
}
