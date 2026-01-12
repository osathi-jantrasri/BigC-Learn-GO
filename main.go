package main

import (
	"log"
	"os"
	"fmt"
  	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/joho/godotenv"
)

func main() {
	app := fiber.New()

	app.Use(cors.New(cors.Config{
		AllowOrigins: "*",
		AllowMethods: "GET,POST,HEAD,PUT,DELETE,PATCH",
		AllowHeaders: "Origin, Content-Type, Accept",
	}))

	app.Use(loggingMiddleware)

	app.Get("/book", getBooks)
	app.Get("/book/:id", getBook)
	app.Post("/book", createBook)
	app.Put("/book/:id", updateBook)
	app.Delete("/book/:id", deleteBook)

	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}
	PORT := os.Getenv("PORT")
	app.Listen(":" + PORT)
}

func loggingMiddleware(c *fiber.Ctx) error {
	start := time.Now()
	err := c.Next()
	duration := time.Since(start)
	fmt.Printf("[%s] %s %s %v\n", start.Format(time.RFC3339), c.Method(), c.OriginalURL(), duration)
	return err
}
