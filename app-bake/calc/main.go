package main

import (
	"calc/handlers"
	"os"
	"strings"

	"github.com/gin-gonic/gin"
	"go.elastic.co/apm/module/apmgin/v2"
)

func main() {

	elkIp, _ := os.ReadFile("/home/ubuntu/elk_lb.txt")
	elkIpStr := "http://" + strings.TrimRight(string(elkIp), "\n") + ":8200"
	os.Setenv("ELASTIC_APM_SERVER_URL", elkIpStr)
	router := gin.Default()
	router.Use(apmgin.Middleware(router))
	router.GET("/calc/:operation/:num1/:num2", handlers.CalcHandler)
	router.GET("/calc/history", handlers.History)
	router.Run() // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")

}
