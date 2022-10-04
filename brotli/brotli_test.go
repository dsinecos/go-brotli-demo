package brotli

import (
	"net/http"
	"testing"

	"github.com/stretchr/testify/assert"
)

func Test_IsBrotliEncodingRequested(t *testing.T) {
	tests := []struct {
		acceptHeader http.Header
		expected     bool
	}{
		{
			acceptHeader: http.Header{
				AcceptEncodingHeader: []string{},
			},
			expected: false,
		},
		{
			acceptHeader: http.Header{
				AcceptEncodingHeader: []string{"gzip"},
			},
			expected: false,
		},
		{
			acceptHeader: http.Header{
				AcceptEncodingHeader: []string{"compress"},
			},
			expected: false,
		},
		{
			acceptHeader: http.Header{
				AcceptEncodingHeader: []string{"br"},
			},
			expected: true,
		},
		{
			// @TODO - What should be the response for this case
			acceptHeader: http.Header{
				AcceptEncodingHeader: []string{"identity"},
			},
			expected: false,
		},
		{
			// @TODO - What should be the response for this case
			acceptHeader: http.Header{
				AcceptEncodingHeader: []string{"*"},
			},
			expected: false,
		},
		{
			acceptHeader: http.Header{
				AcceptEncodingHeader: []string{"deflate, gzip;q=1.0, *;q=0.5"},
			},
			expected: false,
		},
		{
			acceptHeader: http.Header{
				AcceptEncodingHeader: []string{"deflate, gzip;q=1.0, br;q=0.8, *;q=0.5"},
			},
			expected: true,
		},
	}

	for _, test := range tests {
		t.Run("Test IsBrofliEncodingRequested", func(t *testing.T) {

			result := IsBrotliEncodingRequested(test.acceptHeader)

			assert.Equal(t, test.expected, result)
		})
	}

}
