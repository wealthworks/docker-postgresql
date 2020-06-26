VERSION = 11.7
VER12GIS = 12-gis

.PHONY: build

build:
	docker build -t fhyx/postgresql:$(VERSION) .
	docker save -o ~/tmp/fhyx_postgresql_11_7.tar fhyx/postgresql:$(VERSION) && gzip ~/tmp/fhyx_postgresql_11_7.tar

build-11-gis:
	docker build -t fhyx/postgresql:11-gis -f Dockerfile-11-gis .

build-12-gis:
	docker build -t fhyx/postgresql:$(VER12GIS) -f Dockerfile-12-gis .
	docker save -o ~/tmp/fhyx_postgresql_12_gis.tar fhyx/postgresql:$(VER12GIS) && gzip ~/tmp/fhyx_postgresql_12_gis.tar

test:
	docker run --rm -it \
		-e DB_NAME=test -e DB_USER=test -e DB_PASS=mypassword -e TZ=Hongkong \
		  fhyx/postgresql:$(VERSION)
