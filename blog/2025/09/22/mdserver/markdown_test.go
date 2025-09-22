package mdserver

import (
	"bytes"
	"testing"
)

func TestMarkdownToHTML(t *testing.T) {
	tests := []struct {
		name     string
		input    []byte
		expected []byte
		hasError bool
	}{
		{
			name:     "basic markdown",
			input:    []byte("# Heading"),
			expected: []byte("<h1>Heading</h1>\n"),
			hasError: false,
		},
		{
			name:     "empty input",
			input:    []byte(""),
			expected: []byte(""),
			hasError: false,
		},
		{
			name:     "nil input",
			input:    nil,
			expected: []byte(""),
			hasError: false,
		},
		{
			name:     "paragraph",
			input:    []byte("This is a paragraph."),
			expected: []byte("<p>This is a paragraph.</p>\n"),
			hasError: false,
		},
		{
			name:     "link",
			input:    []byte("[Link](https://example.com)"),
			expected: []byte("<p><a href=\"https://example.com\">Link</a></p>\n"),
			hasError: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := MarkdownToHTML(tt.input)
			if (err != nil) != tt.hasError {
				t.Errorf("MarkdownToHTML() error = %v, hasError %v", err, tt.hasError)
				return
			}
			if !bytes.Equal(got, tt.expected) {
				t.Errorf("MarkdownToHTML() = %v, want %v", got, tt.expected)
			}
		})
	}
}
