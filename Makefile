VERSION = 12.10
VER12GIS = 12-gis

.PHONY: main

main:
	docker build -t fhyx/postgresql:13 .

main-tag:
	$(eval VER=$(shell docker run --rm fhyx/postgresql:13 psql --version | awk '{print $$3}'))
	echo "re tag to fhyx/postgresql:$(VER)"
	docker tag fhyx/postgresql:13 fhyx/postgresql:$(VER)
	docker save -o ~/tmp/fhyx_postgresql_13.tar fhyx/postgresql:$(VER) && gzip ~/tmp/fhyx_postgresql_13.tar

build-11-gis:
	docker build -t fhyx/postgresql:11-gis -f Dockerfile-11-gis .

main-12-gis:
	docker build -t fhyx/postgresql:12-gis -f Dockerfile-12-gis .
	docker save -o ~/tmp/fhyx_postgresql_12_gis.tar fhyx/postgresql:12-gis && gzip ~/tmp/fhyx_postgresql_12_gis.tar

test:
	docker run --rm -it \
		-e DB_NAME=test -e DB_USER=test -e DB_PASS=mypassword -e TZ=Hongkong \
		  fhyx/postgresql:12
