DOCKER = docker-compose

all: $(up)

data:
	mkdir -p ./data/{postgres, gogs, jenkins,  testing}


up:
	 

down:
	docker-compose down

# root:
# 	docker exec -it -u root jenkins /bin/bash