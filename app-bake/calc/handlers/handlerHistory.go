package handlers

import (
	"calc/dao"
	"net/http"

	"github.com/gin-gonic/gin"
)

func History(context *gin.Context) {

	client := dao.ConnectRedis()

	data := client.Scan(0, "*", 0).Iterator()
	var values []map[string]string
	for data.Next() {
		val, err := client.HGetAll(data.Val()).Result()
		values = append(values, val)
		if err != nil {
			panic(err)
		}
	}
	if err := data.Err(); err != nil {
		context.JSON(http.StatusServiceUnavailable, "Server down")
	} else {
		context.JSON(http.StatusOK, values)
	}
}
