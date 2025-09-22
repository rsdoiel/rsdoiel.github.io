package mdserver

import (
	"bytes"
	"github.com/yuin/goldmark"
    "github.com/yuin/goldmark/extension"
)

func MarkdownToHTML(source []byte) ([]byte, error) {
	md := goldmark.New(
          goldmark.WithExtensions(extension.GFM),
    )
	var buf bytes.Buffer
	if err := md.Convert(source, &buf); err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}
