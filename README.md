Shell File in q1 Folder

# PIP Version

## Question 1. Understanding Docker images
Run docker with the python:3.13 image. Use an entrypoint bash to interact with the container.

What's the version of pip in the image?

## Answer: 

Create Image Based on the Dockerfile

```bash
docker build -t q1-image .
```

## Create Container and Run

```bash
docker run q1-image
```

Output:
```
pip 25.3 from /usr/local/lib/python3.13/site-packages/pip (python 3.13)
```

# Docker YAML

## Question 2. Understanding Docker networking and docker-compose
Given the following docker-compose.yaml, what is the hostname and port that pgadmin should use to connect to the postgres database?

```yaml
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```

## Answer

Based on [Docker Compose Networking](https://docs.docker.com/compose/how-tos/networking/)
services on the same network should use the CONTAINER_PORT

**db:5432**


# SQL Questions — Green Taxi dataset

This document contains concise SQL queries (Questions 3–6) used to analyze the green taxi dataset. Each query is presented with a short description and a syntax-highlighted SQL block.

SQL FILE IN q3-q6 FOLDER
---

## Question 3 — Counting short trips (November 2025)
How many trips in November 2025 had a `trip_distance` of 1 mile or less? We treat November as: >= 2025-11-01 and < 2025-12-01.

```sql
-- Count trips with distance <= 1 mile in November 2025
SELECT COUNT(*) AS short_trips
FROM green_taxi_data g
WHERE g.lpep_pickup_datetime >= to_timestamp('01-11-2025', 'DD-MM-YYYY')
  AND g.lpep_pickup_datetime <  to_timestamp('01-12-2025', 'DD-MM-YYYY')
  AND g.trip_distance <= 1;
```
## Answer:
```
8007
``` 

---

## Question 4 — Day with the longest total distance
Which pickup day had the largest total trip distance? Exclude trips with `trip_distance >= 100` to avoid data errors.

```sql
-- Day with the largest summed trip_distance (excluding unrealistic values)
SELECT g.lpep_pickup_datetime::date AS pickup_date,
       SUM(g.trip_distance)        AS total_distance
FROM green_taxi_data g
WHERE g.trip_distance < 100
GROUP BY pickup_date
ORDER BY total_distance DESC
LIMIT 1;
```
## Answer:
```
2025-11-20
```
---

## Question 5 — Biggest pickup zone on 2025-11-18
Which pickup zone had the largest `total_amount` on 18-Nov-2025?

```sql
-- Pickup zone with largest total_amount on 2025-11-18
select pu_zone."Zone", gtaxi.lpep_pickup_datetime::date,sum(gtaxi.total_amount)
from green_taxi_data gtaxi
join taxi_zone pu_zone on pu_zone."LocationID" = gtaxi."PULocationID"
where date_trunc('day',gtaxi.lpep_pickup_datetime) = to_timestamp('18-11-2025 00:00:00', 'DD-MM-YYYY HH24:MI:SS') 
group by pu_zone."Zone", gtaxi.lpep_pickup_datetime::date 
order by 3 desc
limit 1;
```
## Answer:
```
East Harlem North
```
---

## Question 6 — Largest tip for pickups in "East Harlem North" (November 2025)
For trips picked up in the `East Harlem North` zone during November 2025, which drop-off zone received the largest total tips?

```sql
-- Drop-off zone with the largest sum of tips for pickups in East Harlem North (Nov 2025)
select do_zone."Zone",sum(gtaxi.tip_amount)
from green_taxi_data gtaxi
join taxi_zone pu_zone on pu_zone."LocationID" = gtaxi."PULocationID"
join taxi_zone do_zone on do_zone."LocationID" = gtaxi."DOLocationID"
where date_trunc('day',gtaxi.lpep_pickup_datetime) >= to_timestamp('01-11-2025 00:00:00', 'DD-MM-YYYY HH24:MI:SS')
and date_trunc('day',gtaxi.lpep_pickup_datetime) <= to_timestamp('30-11-2025 23:59:59', 'DD-MM-YYYY HH24:MI:SS')
and pu_zone."Zone" = 'East Harlem North'
group by do_zone."Zone"
order by 2 desc
limit 1;
```
## Answer:
```
Upper East Side North
```

# Terraform

## Question 7. Terraform Workflow

## Answer
```
terraform init, terraform apply -auto-approve, terraform destroy
``` 





