# statefull services
SERVICES = postgres gogs jenkins testing

# dirs
DATA_DIR := ./data
ENV_DIR := ./envs
CONF_DIR := ./conf
SSL_DIR := $(CONF_DIR)/ssl


# files
SSL_CERT := $(SSL_DIR)/ssl.crt
SSL_KEY := $(SSL_DIR)/ssl.pem

# tools
D = docker
DC = docker-compose


all: dirs envs ssl build

dirs:
	@mkdir -p $(DATA_DIR)
	@mkdir -p $(ENV_DIR)
	@mkdir -p $(SSL_DIR)
	@$(foreach service,$(SERVICES),mkdir -p $(DATA_DIR)/$(service);)

envs: dirs
	@$(foreach service,$(SERVICES),touch $(ENV_DIR)/$(service).env;)


ssl: dirs
	@if [ -e $(SSL_CERT) ]; then \
        echo "SSL exists"; \
    else \
        mkdir -p $(SSL_DIR);\
		openssl req -new -newkey rsa:4096 -days 365 -nodes -x509  -keyout $(SSL_KEY) -out $(SSL_CERT); \
    fi

build: envs ssl
	$(DC) up -d --build

up: envs ssl
	$(DC) up -d

down:
	$(DC) down

ps:
	$(D) ps -a

rjshell:
	$(D) exec -it -u root jenkins /bin/bash


# Clean up the generated data directory and .env files
clean:
	@rm -rf $(DATA_DIR)


# Run `make` or `make help` to display available targets
help:
	@echo "Available targets: all up down clean"

.PHONY: all build up down ps clean help