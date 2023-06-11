package handlers

import (
	"calc/dao"
	"calc/services"
	"calc/validator"
	"net/http"
	"reflect"

	"strconv"

	"github.com/gin-gonic/gin"
)

func CalcHandler(context *gin.Context) {
	operation := context.Param("operation")

	num1, err := validator.ValidadeNum(context.Param("num1"))
	if err != nil {
		context.JSON(http.StatusBadRequest, gin.H{"Error": "invalid number 1"})
		return
	}

	num2, err := validator.ValidadeNum(context.Param("num2"))
	if err != nil {
		context.JSON(http.StatusBadRequest, gin.H{"Error": "invalid number 2"})
		return
	}

	response, errMsg := services.OperationFunc(operation, num1, num2)
	if errMsg != "" {
		context.JSON(http.StatusBadRequest, gin.H{"Error": errMsg})
		return
	}

	client := dao.ConnectRedis()

	responseMap := StructToMap(response)
	numResgistros, _ := client.DBSize().Result()
	errf := client.HMSet(strconv.FormatInt(numResgistros, 10), responseMap).Err()
	if errf != nil {

		context.JSON(http.StatusServiceUnavailable, "Server down")

	} else {

		context.JSON(http.StatusOK, response)
	}
}

func StructToMap(in interface{}) map[string]interface{} {
	out := make(map[string]interface{})
	v := reflect.ValueOf(in)
	t := v.Type()
	for i := 0; i < v.NumField(); i++ {
		field := v.Field(i)
		out[t.Field(i).Name] = field.Interface()
	}
	return out
}
