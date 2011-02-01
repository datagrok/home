package org.datagrok.application;
import java.util.Properties;
import java.awt.Toolkit;
import java.awt.Dimension;
import java.awt.BorderLayout;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.border.*;
import javax.swing.plaf.metal.MetalLookAndFeel;
import javax.swing.UIManager;
import java.awt.Container;
import javax.swing.WindowConstants;
import java.io.IOException;
import java.io.InputStream;

public class Application extends JFrame {
	static { setNiceUI(); }
	protected String appPropertiesFilename = "Application.properties";
	protected Properties properties;

	protected MenuBar menuBar;
	protected StatusBar statusBar;
	protected Container contentPane;

	public Application() {
		super();
		properties = new Properties();
		InputStream propfile = 
			getClass().getResourceAsStream(appPropertiesFilename);
		if (propfile != null) {
			try {
				properties.load(propfile);
			} catch (IOException e) {
				System.err.println(
						"Found but could not load " + appPropertiesFilename + ".");
			}
		}
		//this.setNiceUI();
	}
	public Container getContentPane() {
		return contentPane;
	}
	public void setContentPane(Container cp) {
		if (contentPane != null)
			super.getContentPane().remove(contentPane);
		contentPane = cp;
		super.getContentPane().add(contentPane, BorderLayout.CENTER);
	}
	public void setStatus(String text, int percent) {
		statusBar.setStatus(text, percent);
	}
	public void createGUI() {
		setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
		setTitle(getProperty("name"));
		statusBar = new StatusBar();
		menuBar = new MenuBar();
		menuBar.setAboutMessage(
				String.format("<html><h1>%s %s</h1>"
					+"<p>Version %s</p>"
					+"<p>By %s</p>"
					+"<hr>"
					+"<p>%s</p>"
					+"<p><small>%s</small></p>"
					+"</html>",
					getProperty("company", ""), 
					getProperty("name", "Application"),
					getProperty("version", ""), 
					getProperty("author", "(author)"), 
					getProperty("about", ""),
					getProperty("rcsid", "")
					)
				);
		setJMenuBar(menuBar);
		super.getContentPane().setLayout(new BorderLayout());
		super.getContentPane().add(statusBar, BorderLayout.SOUTH);
		setContentPane(createContentPanel());
	}
	protected Container createContentPanel() {
		return new JPanel();
	}
	public void showGUI() {
		setSize(new Dimension(600,400));
		setLocationRelativeTo(null);
		setVisible(true);
	}
	public static void setNiceUI() {
		try {
			System.err.println ("Setting UI");
			UIManager.setLookAndFeel(new MetalLookAndFeel());
			// only do these if metal succeeds
			JDialog.setDefaultLookAndFeelDecorated(true);
			JFrame.setDefaultLookAndFeelDecorated(true);
			UIManager.put("swing.boldMetal", Boolean.FALSE);
		} catch ( UnsupportedLookAndFeelException e ) {
			System.err.println ("Metal L&F somehow not supported on this platform.");
		}
		// Re-layout the components as the window is being sized
		// Toolkit.getDefaultToolkit().setDynamicLayout(true); // slower, so no.
		// A "hidden property" that fixes some obscure bug; I forgot why I wanted it.
		// System.setProperty("sun.awt.noerasebackground","true");
	}

	public MenuBar getJMenuBar() { return menuBar; }
	public Properties getProperties()	{ return properties; }
	public String setProperty(String k, String v) { return (String)properties.setProperty(k,v); }
	public String getProperty(String k) { return properties.getProperty(k); }
	public String getProperty(String k, String d) { return properties.getProperty(k, d); }
	/* Why did I add this?
	   public static void		setProperties(Properties props) 		{ properties = props; } 
	   public static String		clearProperty(String key) 				{ return (String)properties.remove(key); }
	   */

	/* This is not a thread, but this involves threading. Returns "immediately." */
	public void start() {
		SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				createGUI();
				showGUI();
			}
		});
	}
}

/* vim: set nowrap : */
