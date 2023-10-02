gogs: $(env) $(data)

env:
	echo "" > .env

data:
	mkdir $(SERVICES)/data