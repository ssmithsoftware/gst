package math

import "testing"

func TestAdd(t *testing.T) {
  actual := Add(2, 3)
  expected := 5

  if actual != expected {
    t.Errorf("Add(2, 3) = %d; expected %d", actual, expected)
  }
}

func TestUnsigned(t *testing.T) {
  actual := Unsigned(2, 3)
  var expected uint = 5

  if actual != expected {
    t.Errorf("Unsigned(2, 3) = %d; expected %d", actual, expected)
  }
}
