# Define the list of services
SERVICES = postgres gogs jenkins testing

# Define the base directory for data
DATA_DIR := ./data

# tools
DOCKER = docker-compose

# Run `make all` to perform both prepare and generate-env-files
all: up

# Create the data directory and subdirectories for services
dirs:
	@mkdir -p $(DATA_DIR)
	@$(foreach service,$(SERVICES),mkdir -p $(DATA_DIR)/$(service);)

# Generate empty .env files for each service
dotenv: $(dirs)
	@$(foreach service,$(SERVICES),touch $(DATA_DIR)/$(service).env;)

up: $(dotenv)
	$(DOCKER) up -d

down:
	$(DOCKER) down


# Clean up the generated data directory and .env files
clean:
	@rm -rf $(DATA_DIR)


# Run `make` or `make help` to display available targets
help:
	@echo "Available targets: all up down clean"

.PHONY: all up down clean help