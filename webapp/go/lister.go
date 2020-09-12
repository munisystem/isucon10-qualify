package main

import (
	"fmt"
	"strings"

	"github.com/gomodule/redigo/redis"
)

const InvalidatablePrefix = "invalidatable"

func Ensure(table string, condition string, param interface{}) (string, error) {
	conn := redigoPool.Get()
	defer conn.Close()

	key := redisKey(table, condition, param)
	exist, err := redis.Bool(conn.Do("EXISTS", key))
	if err != nil {
		return "", err
	}

	if exist {
		return key, nil
	}

	searchQuery := fmt.Sprintf("SELECT id FROM %s WHERE ", table)
	ids := []int64{}
	err = db.Select(&ids, searchQuery+condition, param)
	if err != nil {
		return "", err
	}

	conn.Send("MULTI")
	for _, id := range ids {
		err := conn.Send("SADD", key, id)
		if err != nil {
			return "", err
		}
	}
	_, err = conn.Do("EXEC")
	if err != nil {
		return "", err
	}

	return key, nil
}

func Get(table string, keys []string) ([]string, error) {
	conn := redigoPool.Get()
	defer conn.Close()

	key := intersectionKey(table, keys)
	exist, err := redis.Bool(conn.Do("EXISTS", key))
	if err != nil {
		return nil, err
	}

	if !exist {
		args := []interface{}{key}
		for _, k := range keys {
			args = append(args, k)
		}
		_, err := conn.Do("SINTERSTORE", args...)
		if err != nil {
			return nil, err
		}
	}

	ids, err := redis.Strings(conn.Do("SMEMBERS", key))
	if err != nil {
		return nil, err
	}

	return ids, nil
}

func redisKey(table string, condition string, param interface{}) string {
	return fmt.Sprintf("%s:%s:%s:%v", InvalidatablePrefix, table, condition, param)
}

func intersectionKey(table string, keys []string) string {
	return fmt.Sprintf("%s:%s:intersection:%s", InvalidatablePrefix, table, strings.Join(keys, ":"))
}

func Invalidate(table string) error {
	conn := redigoPool.Get()
	defer conn.Close()

	_, err := conn.Do("EVAL", fmt.Sprintf(`return redis.call('del', unpack(redis.call('keys', ARGV[1])))" 0 %s:%s*]`, InvalidatablePrefix, table))
	if err != nil {
		return err
	}
	return nil
}
