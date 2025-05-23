import csv
import json
from time import time

from kafka import KafkaProducer


def main():
    # Create a Kafka producer
    producer = KafkaProducer(
        bootstrap_servers="localhost:9092",
        value_serializer=lambda v: json.dumps(v).encode("utf-8"),
    )

    csv_file = (
        "data/green_tripdata_2019-10.csv"  # change to your CSV file path if needed
    )
    t0 = time()
    with open(csv_file, "r", newline="", encoding="utf-8") as file:
        reader = csv.DictReader(file)

        for row in reader:
            # Each row will be a dictionary keyed by the CSV headers
            # Send data to Kafka topic "green-data"
            producer.send("green-trips", value=row)

    # Make sure any remaining messages are delivered
    producer.flush()
    producer.close()
    t1 = time()
    took = t1 - t0
    print(f"Sent messages to Kafka in {took:.2f} seconds")


if __name__ == "__main__":
    main()
