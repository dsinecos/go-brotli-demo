package brotli

import (
	"net/http"
	"strings"
)

const (
	AcceptEncodingHeader      = "Accept-Encoding"
	BrotliEncodingHeaderValue = "br"
)

func IsBrotliEncodingRequested(header http.Header) bool {
	encodingHeaders := header.Get(AcceptEncodingHeader)

	if encodingHeaders == "" {
		return false
	}

	encodingHeadersSlice := strings.Split(encodingHeaders, ",")
	var headerValues []string
	for _, value := range encodingHeadersSlice {
		valueSlice := strings.Split(value, ";")
		headerValues = append(headerValues, valueSlice[0])
	}

	for _, value := range headerValues {
		if strings.TrimSpace(value) == "br" {
			return true
		}
	}

	return false
}
