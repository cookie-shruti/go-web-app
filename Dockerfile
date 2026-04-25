FROM golang:1.22 AS base

WORKDIR /app

COPY go.mod .    
#dependency manager and tracks app versions

RUN go mod download 
# It downloads all the dependencies (libraries) listed in your go.mod file

COPY . .
# Copy everything from your local project → into the container

RUN go build -o main .
# Run the image


#Final stage - Distroless image
FROM gcr.io/distroless/base
# Use minimal secure base image (no shell, no extra packages)

COPY --from=base /app/main .
# Copy compiled Go binary 'main' from previous build stage (named 'base') into this image

COPY --from=base /app/static ./static
# Copy static files (HTML/CSS/JS etc.) from build stage into container

EXPOSE 8080
# Inform Docker that container will run on port 8080 (for web app)

CMD [ "./main" ]




