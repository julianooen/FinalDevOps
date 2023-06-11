package validator

import "strconv"

func ValidadeNum(num string) (float64, error) {
	numConvert, err := strconv.ParseFloat(num, 64)
	if err != nil {
		numConvert = 0
	}
	return numConvert, err
}
