package main

import (
	"fmt"
	"net/http"
	"os"
	"strconv"

	auth0middleware "app-ps-comp-summary/middleware"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

type Config struct {
	Port                  int
}

func getConfig() Config {
	port, err := strconv.Atoi(os.Getenv("PORT"))
	if err != nil {
		port = 10000
	}

	return Config{
		Port:                  port,
	}
}

func auth0Middleware(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			next(c)
		})
		auth0Handler := auth0middleware.EnsureValidToken()(handler)
		auth0Handler.ServeHTTP(c.Response(), c.Request())
		return nil
	}
}

func main() {
	config := getConfig()

	e := echo.New()
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())
	e.Use(middleware.CORS())
	e.Use(auth0Middleware)

	e.GET("/", func(c echo.Context) error {
		return c.JSON(http.StatusOK, "Hello, World!")
	})

	e.Start(fmt.Sprintf(":%s", strconv.Itoa(config.Port)))
}