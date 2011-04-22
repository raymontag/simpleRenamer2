EXEC=simpleRenamer
SOURCES=src/simpleRenamer.vala
PKG=gee-1.0
PREFIX=/usr

all:
	valac $(SOURCES) --pkg $(PKG) -o $(EXEC)

install:
	install -m 0775 simpleRenamer $(PREFIX)/bin

clean:
	rm simpleRenamer

