VERSION = 12.10
VER12GIS = 12-gis

.PHONY: main

main:
	docker build -t fhyx/postgresql:stab .

main-tag:
	$(eval VER=$(shell docker run --rm fhyx/postgresql:stab psql --version | awk '{print $$3}'))
	echo "re tag to fhyx/postgresql:$(VER)"
	docker tag fhyx/postgresql:stab fhyx/postgresql:$(VER)
	docker save -o ~/tmp/fhyx_postgresql_stab.tar fhyx/postgresql:$(VER) && gzip ~/tmp/fhyx_postgresql_stab.tar

v13:
	docker build -t fhyx/postgresql:13 -f Dockerfile-13 .

v13-tag:
	$(eval VER=$(shell docker run --rm fhyx/postgresql:13 psql --version | awk '{print $$3}'))
	echo "re tag to fhyx/postgresql:$(VER)"
	docker tag fhyx/postgresql:13 fhyx/postgresql:$(VER)

v14:
	docker build -t fhyx/postgresql:14 -f Dockerfile-14 .

v14-tag:
	$(eval VER=$(shell docker run --rm fhyx/postgresql:14 psql --version | awk '{print $$3}'))
	echo "re tag to fhyx/postgresql:$(VER)"
	docker tag fhyx/postgresql:14 fhyx/postgresql:$(VER)

v15:
	docker build -t fhyx/postgresql:15 -f Dockerfile-15 .

v15-tag:
	$(eval VER=$(shell docker run --rm fhyx/postgresql:15 psql --version | awk '{print $$3}'))
	echo "re tag to fhyx/postgresql:$(VER)"
	docker tag fhyx/postgresql:15 fhyx/postgresql:$(VER)

v15e:
	docker build -t fhyx/postgresql:15e -f Dockerfile-15-ext .

v15e-tag:
	$(eval VER=$(shell docker run --rm fhyx/postgresql:15e psql --version | awk '{print $$3}'))
	echo "re tag to fhyx/postgresql:$(VER)"
	docker tag fhyx/postgresql:15e fhyx/postgresql:$(VER)

build-11-gis:
	docker build -t fhyx/postgresql:11-gis -f Dockerfile-11-gis .

main-12-gis:
	docker build -t fhyx/postgresql:12-gis -f Dockerfile-12-gis .
	docker save -o ~/tmp/fhyx_postgresql_12_gis.tar fhyx/postgresql:12-gis && gzip ~/tmp/fhyx_postgresql_12_gis.tar

test:
	docker run --rm -it \
		-e DB_NAME=test -e DB_USER=test -e DB_PASS=mypassword -e TZ=Hongkong \
		  fhyx/postgresql:12
