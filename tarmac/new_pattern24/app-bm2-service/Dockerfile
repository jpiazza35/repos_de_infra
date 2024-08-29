# Set Go version through build args in docker build or use 1.20
ARG GO_VERSION=1.20

FROM golang:${GO_VERSION}

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build the Go app
RUN go build -o main .

# Expose port 10000 to the outside
# Can be set with ENV variable PORT also
EXPOSE 10000

# Command to run the executable
CMD ["./main"]