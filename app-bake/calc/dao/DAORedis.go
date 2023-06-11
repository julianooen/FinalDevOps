package dao

import (
	"os"
	"strings"

	"github.com/go-redis/redis"
)

func ConnectRedis() *redis.Client {
	redisIp, _ := os.ReadFile("/home/ubuntu/nlb_dns.txt")
	redisIpStr := strings.TrimRight(string(redisIp), "\n") + ":6379"

	client := redis.NewClient(&redis.Options{
		Addr:     redisIpStr,
		Password: "", // sem senha definida
		DB:       0,  // use o banco de dados padrão
	})
	return client
}
