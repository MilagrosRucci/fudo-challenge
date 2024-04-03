# Fudo challenge

This application leverages various technologies to work effectively. It uses Rack, a modular web server interface, to handle HTTP requests and responses. For background processing, it uses Sidekiq, which in turn relies on Redis, an in-memory data structure store, for job storage and processing. Redis is also used in this application for session management, providing a fast and efficient way to manage user sessions. For testing purposes, the application uses Minitest and Rack::Test, a small and simple testing API for Rack applications. These tools together ensure that the application runs smoothly and reliably.

## Getting started

### Building the application

The `bin/docker.sh` script is used to build the Docker image for the application. You can run it as follows:

`./bin/docker.sh`

This will build the Docker image and set it up for running.

### Running the tests

The `run_tests.sh` script is used to run the tests for the application. You can run it as follows:

`docker exec -ti fudo-container ./bin/run_tests.sh`

### Seed data

The seed script is used to seed the database with sample data. You can run it as follows:

`docker exec -ti fudo-container ruby db/seed.rb`

## CURL examples

### Login user

Request:

`curl -X POST -d "username=user1&password=password1" http://localhost:9393/login`

Response:

```
{"token":"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6InVzZXIxIn0.jQEYwHK2DOfKcBD_vdl31x8-fx-4oo6AJLBRja9wnlU"}
```

### Create a product

Request:

`curl -X POST -d "name=aproduct" -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6InVzZXIxIn0.jQEYwHK2DOfKcBD_vdl31x8-fx-4oo6AJLBRja9wnlU" http://localhost:9393/products`

Response:

```
{"message":"The product 'aproduct' has been created successfully"}
```

### Get products

Request:

`curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6InVzZXIxIn0.jQEYwHK2DOfKcBD_vdl31x8-fx-4oo6AJLBRja9wnlU" http://localhost:9393/products`

Response:

```
[{"id":1,"name":"Product 1"},{"id":2,"name":"Product 2"},{"id":3,"name":"Product 3"},{"id":4,"name":"Product 4"},{"id":5,"name":"Product 5"},{"id":6,"name":"Product 6"},{"id":7,"name":"Product 7"},{"id":8,"name":"Product 8"},{"id":9,"name":"Product 9"},{"id":10,"name":"Product 10"},{"id":11,"name":"Product 11"},{"id":12,"name":"Product 12"},{"id":13,"name":"Product 13"},{"id":14,"name":"Product 14"},{"id":15,"name":"Product 15"},{"id":16,"name":"Product 16"},{"id":17,"name":"Product 17"},{"id":18,"name":"Product 18"},{"id":19,"name":"Product 19"},{"id":20,"name":"Product 20"},{"id":21,"name":"Product 21"},{"id":22,"name":"Product 22"},{"id":23,"name":"Product 23"},{"id":24,"name":"Product 24"},{"id":25,"name":"Product 25"},{"id":26,"name":"Product 26"},{"id":27,"name":"Product 27"},{"id":28,"name":"Product 28"},{"id":29,"name":"Product 29"},{"id":30,"name":"Product 30"},{"id":31,"name":"Product 31"},{"id":32,"name":"Product 32"},{"id":33,"name":"Product 33"},{"id":34,"name":"Product 34"},{"id":35,"name":"Product 35"},{"id":36,"name":"Product 36"},{"id":37,"name":"Product 37"},{"id":38,"name":"Product 38"},{"id":39,"name":"Product 39"},{"id":40,"name":"Product 40"},{"id":41,"name":"Product 41"},{"id":42,"name":"Product 42"},{"id":43,"name":"Product 43"},{"id":44,"name":"Product 44"},{"id":45,"name":"Product 45"},{"id":46,"name":"Product 46"},{"id":47,"name":"Product 47"},{"id":48,"name":"Product 48"},{"id":49,"name":"Product 49"},{"id":50,"name":"Product 50"},{"id":51,"name":"aproduct"}]
```

Optionally, all products can be requested in gzip format.
You can add the following header to the previous request: `-H "Accept-Encoding: gzip" --output products.gzip`

### Get authors

Request:

`curl -i http://localhost:9393/AUTHORS`

Response:

```
HTTP/1.1 200 OK
Last-Modified: Sun, 31 Mar 2024 20:25:42 GMT
Content-Type: text/plain
Date: Wed, 03 Apr 2024 02:46:29 GMT
Cache-Control: s-maxage=86400
X-Content-Digest: 5239f9201a705e775b03d49c4e8fccd45c65e1ee
Content-Length: 14
Age: 198
X-Rack-Cache: fresh
Vary: Accept-Encoding
Server: WEBrick/1.8.1 (Ruby/3.3.0/2023-12-25)
Connection: Keep-Alive

Milagros Rucci
```

### Get Openapi documentation

Request:

`curl http://localhost:9393/openapi.yaml`

Response:

```
openapi: "3.0.0"
info:
  version: 1.0.0
  title: FUDO Challenge API
paths:
  /login:
    post:
      summary: Login a user
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                username:
                  type: string
                password:
                  type: string
      responses:
        "200":
          description: Successful login
          content:
            application/json:
              schema:
                type: object
                properties:
                  token:
                    type: string
        "401":
          description: Invalid credentials
          content:
            application/json:
              schema:
                type: object
                properties:
                  error:
                    type: string
  /products:
    get:
      summary: Returns a list of products
      parameters:
        - in: header
          name: Authorization
          schema:
            type: string
          required: true
        - in: header
          name: Accept-Encoding
          schema:
            type: string
          description: Request gzip encoding for response (optional)
      responses:
        "200":
          description: A JSON array of products
          content:
            application/json:
              schema:
                type: array
                items:
                  type: object
        "401":
          description: Invalid token
          content:
            application/json:
              schema:
                type: object
                properties:
                  error:
                    type: string
    post:
      summary: Create a new product
      parameters:
        - in: header
          name: Authorization
          schema:
            type: string
          required: true
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                name:
                  type: string
      responses:
        "201":
          description: Product created successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  message:
                    type: string
        "401":
          description: Invalid token
          content:
            application/json:
              schema:
                type: object
                properties:
                  message:
                    type: string
  /AUTHORS:
    get:
      summary: Get authors information
      responses:
        "200":
          description: Authors information
          content:
            text/plain:
              schema:
                type: string
```
