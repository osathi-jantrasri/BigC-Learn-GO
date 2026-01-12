package main

import (
	"fmt"

	"github.com/gofiber/fiber/v2"
)

func main() {
	fmt.Println("Hello moon")

	app := fiber.New()

	app.Get("/book", getBooks)
	app.Get("/book/:id", getBook)
	app.Post("/book", createBook)
	app.Put("/book/:id", updateBook)
	app.Delete("/book/:id", deleteBook)

	app.Listen(":8080")
}
