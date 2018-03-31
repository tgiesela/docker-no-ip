docker run --name=no-ip -d \
	-v /etc/localtime:/etc/localtime \
	-v $PWD/:/config \
	tgiesela/no-ip:v0.1
