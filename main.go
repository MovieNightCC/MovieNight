package main

// [START fs_initialize]
// [START firestore_setup_client_create]
import (
	"context"
	"fmt"
	"log"

	"google.golang.org/api/iterator"

	"cloud.google.com/go/firestore"
)

func createClient(ctx context.Context) *firestore.Client {
	// This is the Cloud Platform Project ID.
	projectID := "movie-night-cc"

	client, err := firestore.NewClient(ctx, projectID)
	if err != nil {
		log.Fatalf("Failed to create client: %v", err)
	}
	// Close client when done with
	// defer client.Close()
	return client
}

// [END firestore_setup_client_create]
// [END fs_initialize]

func main() {
	// Get a Firestore client.
	ctx := context.Background()
	client := createClient(ctx)
	defer client.Close()

	// [START fs_add_data_1]
	// [START firestore_setup_dataset_pt1]
	_, _, err := client.Collection("users").Add(ctx, map[string]interface{}{
		"first": "Ada",
		"last":  "Lovelace",
		"born":  1815,
	})
	if err != nil {
		log.Fatalf("Failed adding alovelace: %v", err)
	}
	// [END firestore_setup_dataset_pt1]
	// [END fs_add_data_1]

	// [START fs_add_data_2]
	// [START firestore_setup_dataset_pt2]
	_, _, err = client.Collection("users").Add(ctx, map[string]interface{}{
		"first":  "Alan",
		"middle": "Mathison",
		"last":   "Turing",
		"born":   1912,
	})
	if err != nil {
		log.Fatalf("Failed adding aturing: %v", err)
	}
	// [END firestore_setup_dataset_pt2]
	// [END fs_add_data_2]

	// [START fs_get_all_users]
	// [START firestore_setup_dataset_read]
	iter := client.Collection("users").Documents(ctx)
	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Fatalf("Failed to iterate: %v", err)
		}
		fmt.Println(doc.Data())
	}
	// [END firestore_setup_dataset_read]
	// [END fs_get_all_users]
}
