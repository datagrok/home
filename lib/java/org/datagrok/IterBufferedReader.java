package org.datagrok;
import java.io.BufferedReader;
import java.io.Reader;
import java.util.*;
import java.io.IOException;
public class IterBufferedReader extends BufferedReader implements Iterator<String>, Iterable<String> {
	public IterBufferedReader(Reader r) 		{ super(r); }
	public IterBufferedReader(Reader r, int sz)	{ super(r, sz); }
	public String next() {
		try {
			return readLine();
		} catch (IOException ioe) {
			throw new NoSuchElementException(ioe.getMessage());
		}
	}
	public boolean hasNext() {
		try {
			return ready();
		} catch (IOException ioe) {
			return false;
		}
	}
	public void remove() {
		throw new UnsupportedOperationException();
	}
	public Iterator<String> iterator() {
		return this;
	}
}
