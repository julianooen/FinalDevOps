package services

import (
	"calc/calculator"
	"calc/entities"
)

var res float64

func OperationFunc(operator string, num1 float64, num2 float64) (resJson entities.CalcResult, errMsg string) {

	switch operator {
	case "sum":
		res = calculator.Sum(num1, num2)
	case "sub":
		res = calculator.Sub(num1, num2)
	case "mul":
		res = calculator.Mul(num1, num2)
	case "div":
		if num2 == 0 {
			errMsg = "Invalid division by zero!"
			return
		}
		res = calculator.Div(num1, num2)
	default:
		errMsg = "Invalid operation: " + operator
	}
	if errMsg != "" {
		return resJson, errMsg
	}
	resJson = toJson(operator, num1, num2, res)
	return resJson, errMsg
}

func toJson(operator string, num1 float64, num2 float64, res float64) entities.CalcResult {
	operationRes := entities.CalcResult{Operation: operator, Num1: num1, Num2: num2, Result: res}
	return operationRes
}
