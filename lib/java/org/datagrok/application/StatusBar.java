package org.datagrok.application;
import javax.swing.JPanel;
public class StatusBar extends JPanel {
	javax.swing.JLabel status;
	javax.swing.JProgressBar progress;
	public StatusBar() {
		super();
		status = new javax.swing.JLabel("Ready");
		progress = new javax.swing.JProgressBar(0, 100);
		setLayout(new java.awt.BorderLayout());
		setBorder(new javax.swing.border.EtchedBorder());
		add(status, java.awt.BorderLayout.WEST);
		add(progress, java.awt.BorderLayout.EAST);
	}
	public void setText(String s) {
		status.setText(s);
	}
	public String getText() {
		return status.getText();
	}
	public javax.swing.JProgressBar getProgressBar() {
		return progress;
	}
	public void setPercentComplete(int p) {
		progress.setValue(p);
		progress.setIndeterminate(false);
	}
	public void setStatus(String text, int percent) {
		setText(text);
		if (percent < 0)
			progress.setIndeterminate(true);
		else
			setPercentComplete(percent);
	}
}
