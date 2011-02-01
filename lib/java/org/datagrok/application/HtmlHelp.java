package org.datagrok.application;
// Derived from MetalworksHelp.java, JDK 5.0 demos.
import javax.swing.*;
import java.awt.*;
import java.net.URL;
import java.net.MalformedURLException;
import java.io.*;
import javax.swing.text.*;
import javax.swing.event.*;
/*
 * @version 1.12 07/26/04
 * @author Steve Wilson
 */
public class HtmlHelp extends JFrame {
	public HtmlHelp()
		throws MalformedURLException, FileNotFoundException, IOException {
		super("Help");
		setBounds(200, 25, 400, 400);
		HtmlPane html = new HtmlPane();
		setContentPane(html);
		setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
	}
}
class HtmlPane extends JScrollPane implements HyperlinkListener {
	JEditorPane html;
	public HtmlPane()
		throws MalformedURLException, FileNotFoundException, IOException {
		this("HelpFiles/toc.html");
	}
	public HtmlPane(String toc) 
		throws MalformedURLException, FileNotFoundException, IOException {
		super();
		File f = new File(toc);
		String s = f.getAbsolutePath();
		s = "file:" + s;
		URL url = new URL(s);
		html = new JEditorPane(s);
		html.setEditable(false);
		html.addHyperlinkListener(this);
		JViewport vp = getViewport();
		vp.add(html);
	}
	/**
	 * Notification of a change relative to a 
	 * hyperlink.
	 */
	public void hyperlinkUpdate(HyperlinkEvent e) {
		if (e.getEventType() == HyperlinkEvent.EventType.ACTIVATED) {
			linkActivated(e.getURL());
		}
	}
	/**
	 * Follows the reference in an
	 * link.  The given url is the requested reference.
	 * By default this calls <a href="#setPage">setPage</a>,
	 * and if an exception is thrown the original previous
	 * document is restored and a beep sounded.  If an 
	 * attempt was made to follow a link, but it represented
	 * a malformed url, this method will be called with a
	 * null argument.
	 *
	 * @param u the URL to follow
	 */
	protected void linkActivated(URL u) {
		Cursor c = html.getCursor();
		Cursor waitCursor = Cursor.getPredefinedCursor(Cursor.WAIT_CURSOR);
		html.setCursor(waitCursor);
		SwingUtilities.invokeLater(new PageLoader(u, c));
	}
	/**
	 * temporary class that loads synchronously (although
	 * later than the request so that a cursor change
	 * can be done).
	 */
	class PageLoader implements Runnable {
		PageLoader(URL u, Cursor c) {
			url = u;
			cursor = c;
		}
		public void run() {
			if (url == null) {
				// restore the original cursor
				html.setCursor(cursor);
				// PENDING(prinz) remove this hack when 
				// automatic validation is activated.
				Container parent = html.getParent();
				parent.repaint();
			} else {
				Document doc = html.getDocument();
				try {
					html.setPage(url);
				} catch (IOException ioe) {
					html.setDocument(doc);
					getToolkit().beep();
				} finally {
					// schedule the cursor to revert after
					// the paint has happended.
					url = null;
					SwingUtilities.invokeLater(this);
				}
			}
		}
		URL url;
		Cursor cursor;
	}
}
