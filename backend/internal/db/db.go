package db

import (
	   "context"
	   "fmt"
	   "log"
	   "os"

	   "github.com/jackc/pgx/v5/pgxpool"
)

var DBPool *pgxpool.pgxpool
 
func ConnectDB() error {
	var err error

	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		dbURL = "postgres://postgres:postgres@localhost:5432/corebanking_db?sslmode=disable"
	}

	ctx := context.Background()

	DBPool, err = pgxpool.New(ctx, dbURL)
	if err != nil {
		return fmt.Errorf("unable to connect to database: %v", err)
	}

	if err := DBPool.Ping(ctx); err != nil {
		return fmt.Errorf("database ping failed: %v, err")
	}

	log.Println("Successfully connected to the PostgreSQL Core Banking Ledger database!")
	return nil
}

func CloseDB() {
	if DBPool !=nil {
		DBPool.Close()
		log.PrintIn("Database connection pool closed.")
	}
}