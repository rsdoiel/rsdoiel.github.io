package mdserver

import (
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"testing"
)

func TestMarkdownHandler(t *testing.T) {
	// Create a temporary directory with some test files
	testDir := "test_data"
	err := os.Mkdir(testDir, 0775)
	if err != nil {
		t.Fatal(err)
	}
	defer os.RemoveAll(testDir)

	// Create a test Markdown file
	mdFilePath := filepath.Join(testDir, "test.md")
	mdContent := []byte("# Test Heading")
	err = os.WriteFile(mdFilePath, mdContent, 0644)
	if err != nil {
		t.Fatal(err)
	}

	// Create a test non-Markdown file
	txtFilePath := filepath.Join(testDir, "test.txt")
	txtContent := []byte("Plain text file")
	err = os.WriteFile(txtFilePath, txtContent, 0644)
	if err != nil {
		t.Fatal(err)
	}

	// Create a FileSystem from the temporary directory
	fs := http.Dir(testDir)

	// Create a file server handler for the FileSystem
	fileServer := http.FileServer(fs)

	// Create the Markdown handler
	handler := MarkdownHandler(fileServer)

	// Test cases
	tests := []struct {
		name           string
		path           string
		expectedStatus int
		expectedBody   string
	}{
		{
			name:           "valid markdown file",
			path:           "/test.md",
			expectedStatus: http.StatusOK,
			expectedBody:   "<h1>Test Heading</h1>\n",
		},
		{
			name:           "non-markdown file",
			path:           "/test.txt",
			expectedStatus: http.StatusOK,
			expectedBody:   "Plain text file",
		},
		{
			name:           "non-existent file",
			path:           "/nonexistent.md",
			expectedStatus: http.StatusNotFound,
			expectedBody:   "404 page not found\n", // Updated to match the custom message
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// Create a request to the handler
			req, err := http.NewRequest("GET", tt.path, nil)
			if err != nil {
				t.Fatal(err)
			}

			// Create a response recorder to record the response
			rr := httptest.NewRecorder()

			// Call the handler
			handler.ServeHTTP(rr, req)

			// Check the status code
			if status := rr.Code; status != tt.expectedStatus {
				t.Errorf("handler returned wrong status code: got %v want %v", status, tt.expectedStatus)
			}

			// Check the response body
			body := rr.Body.String()
			if body != tt.expectedBody {
				t.Errorf("handler returned unexpected body: got '%v' want %v", body, tt.expectedBody)
			}
		})
	}
}
