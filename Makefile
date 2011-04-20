EXEC=simpleRenamer
SOURCES=src/simpleRenamer.vala
PREFIX=/usr

all:
	valac $(SOURCES) -o $(EXEC)

install:
	install -m 0775 simpleRenamer $(PREFIX)/bin

clean:
	rm simpleRenamer

