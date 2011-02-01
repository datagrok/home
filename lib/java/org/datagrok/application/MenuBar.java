package org.datagrok.application;
import javax.swing.*;
import javax.swing.Action;
import javax.swing.AbstractAction;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JSeparator;
import javax.swing.KeyStroke;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import javax.swing.Box;

/** My "special" Menu Bar.
 * Sets by default to have:
 *  - File (Application)
 *    - Quit
 *  - Edit
 *    - Cut
 *    - Copy
 *    - Paste
 *  - Help
 *    - About
 *    - Contents
 * And sane mnemonincs and shortcut keys.
 */
public class MenuBar extends JMenuBar {
	private JMenu file;
	private JMenu help;
	private JMenuItem exit;
	private JMenuItem helpContents;
	private JMenuItem about;
	private String aboutMessage = null;
	protected HtmlHelp helpFrame = null;
	public MenuBar () {
		super();

		try {
			helpFrame = new HtmlHelp();
		} catch (Exception e) {
			System.err.println(e);
			System.err.println("Could not enable help system.");
		}

		file = new JMenu("File") {{
			setMnemonic('F');
			addSeparator();
		}};

		help = new JMenu("Help") {{
			setMnemonic('H');
			addSeparator();
		}};

		exit = file.add(new AbstractAction("Exit") {
			{	putValue(MNEMONIC_KEY, KeyEvent.VK_X);
				putValue(ACCELERATOR_KEY,
					KeyStroke.getKeyStroke('Q', ActionEvent.CTRL_MASK));
			}
			public void actionPerformed(ActionEvent e) {
				System.exit(0);
			}
		});

		helpContents = help.add(new AbstractAction("Help Contents") {
			{	putValue(MNEMONIC_KEY, KeyEvent.VK_C);
				putValue(ACCELERATOR_KEY, 
					KeyStroke.getKeyStroke(KeyEvent.VK_F1, 0));
				setEnabled(helpFrame != null);
			}
			public void actionPerformed(ActionEvent e) {
				helpFrame.setVisible(true);
			}
		});

		about = help.add(new AbstractAction("About") {
			{	putValue(MNEMONIC_KEY, KeyEvent.VK_A);
				setEnabled(aboutMessage != null);
			}
			public void actionPerformed(ActionEvent e) {
				JOptionPane.showMessageDialog(getParent(), aboutMessage, "About", JOptionPane.INFORMATION_MESSAGE);
			}
		});

		add(file);
		add(help);
		// consider a try/catch block for setHelpMenu when it's implemented.
	}

	public JMenuItem replaceMenuItem(JMenu jm,
			JMenuItem old, Action replacement) {
		int i, c;
		c = jm.getItemCount();
		for (i=0; i<c; i++)
			if (jm.getItem(i) == old) break;
		if (old != null)
			jm.remove(old);
		return jm.insert(replacement, i+1);
	}

	public void setExitAction(Action a) {
		exit = replaceMenuItem(file, exit, a);
	}
	public void setHelpContentsAction(Action a) {
		helpContents = replaceMenuItem(help, helpContents, a);
	}
	public void setAboutAction(Action a) {
		about = replaceMenuItem(help, about, a);
	}
	public void setAboutMessage(String s) {
		aboutMessage = s;
		about.setEnabled(true);
	}

	public JMenu getFileMenu(){ return file; }
	public JMenu getHelpMenu(){ return help; }
	public JMenu addMenu(javax.swing.JMenu M) {
		// Insert a menu before default "help"
		add(M, getComponentCount() - 2);
		return M;
	}
	public JMenuItem addMenuItem(JMenu menu, Action toadd) {
		if (menu == file)
			return file.insert(toadd, file.getItemCount()-2);
		else if (menu == help)
			return help.insert(toadd, file.getItemCount()-2);
		else
			return menu.add(toadd);
	}
	public void addSeparator(JMenu menu) {
		if (menu == file)
			file.insertSeparator(file.getItemCount()-2);
		else if (menu == help)
			help.insertSeparator(file.getItemCount()-2);
		else
			menu.addSeparator();
	}
}
