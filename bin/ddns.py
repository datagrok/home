from datagrok.dreamhostapi import main
from sys import argv

if __name__ == "__main__":

    if not len(argv) == 2:
        raise SystemExit("Error: api key and hostname are required arguments.")

    main(argv[1], argv[2])
