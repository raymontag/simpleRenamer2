EXEC=simpleRenamer
SOURCES=src/simpleRenamer.vala
PKG=--pkg gee-1.0 --pkg gio-2.0
PREFIX=/usr

all:
	valac $(SOURCES) $(PKG) -o $(EXEC)

install:
	install -m 0775 simpleRenamer $(PREFIX)/bin

clean:
	rm simpleRenamer

