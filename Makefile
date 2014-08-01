install:
	mkdir -p /usr/local/aws-ssh
	cp * /usr/local/aws-ssh
	ln -nfs /usr/local/aws-ssh/aws-ssh /usr/local/bin/aws-ssh

.PHONEY: install
