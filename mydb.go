package main

import (
	"database/sql"
	"fmt"
	"os"
	"log"
)

var db *sql.DB

func initDB() *sql.DB{
	var dbHost = os.Getenv("DB_HOST")
	var dbPort = os.Getenv("DB_PORT")
	var dbUser = os.Getenv("DB_USER")
	var dbPassword = os.Getenv("DB_PASSWORD")
	var dbName = os.Getenv("DB_NAME")

	connectionstring := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable", dbHost, dbPort, dbUser, dbPassword, dbName)
	db, err := sql.Open("postgres", connectionstring)
	if err != nil {
		log.Fatal(err)
	}
	return db
}