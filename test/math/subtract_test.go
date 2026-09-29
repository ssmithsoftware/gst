package math

import "testing"

func TestSubtract(t *testing.T) {
  actual := Subtract(2, 3)
  expected := -1

  if actual != expected {
    t.Errorf("Subtract(2, 3) = %d; expected %d", actual, expected)
  }
}
