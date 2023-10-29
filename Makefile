# Define the list of services
SERVICES = postgres gogs jenkins testing

# Define the base directory for data
DATA_DIR := ./data

SSL_DIR := $(DATA_DIR)/nginx/ssl
SSL_CERT := $(SSL_DIR)/ssl.crt
SSL_KEY := $(SSL_DIR)/ssl.pem

# tools
DOCKER = docker-compose

# Run `make all` to perform both prepare and generate-env-files
all: build

# Create the data directory and subdirectories for services
dirs:
	@mkdir -p $(DATA_DIR)
	@mkdir -p $(SSL_DIR)
	@$(foreach service,$(SERVICES),mkdir -p $(DATA_DIR)/$(service);)

# Generate empty .env files for each service
dotenv: dirs
	@$(foreach service,$(SERVICES),touch $(DATA_DIR)/$(service).env;)

ssl:
	@if [ -e $(SSL_CERT) ]; then \
        echo "SSL exists"; \
    else \
        mkdir -p $(SSL_DIR);\
		openssl req -new -newkey rsa:4096 -days 365 -nodes -x509  -keyout $(SSL_KEY) -out $(SSL_CERT); \
    fi

build: dotenv ssl
	$(DOCKER) up -d --build

up: dotenv ssl
	$(DOCKER) up -d

down:
	$(DOCKER) down


ps:
	docker ps -a

rjshell:
	docker exec -it -u root jenkins /bin/bash


# Clean up the generated data directory and .env files
clean:
	@rm -rf $(DATA_DIR)


# Run `make` or `make help` to display available targets
help:
	@echo "Available targets: all up down clean"

.PHONY: all build up down ps clean help