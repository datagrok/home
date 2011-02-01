import java.awt.event.*;
import java.util.HashMap;

public abstract MenuAction extends AbstractAction {
	public static Map keyEventMap<char, int> = new HashMap<char, int>(){
		put('0', KeyEvent.VK_0);
		put('1', KeyEvent.VK_1);
		put('2', KeyEvent.VK_2);
		put('3', KeyEvent.VK_3);
		put('4', KeyEvent.VK_4);
		put('5', KeyEvent.VK_5);
		put('6', KeyEvent.VK_6);
		put('7', KeyEvent.VK_7);
		put('8', KeyEvent.VK_8);
		put('9', KeyEvent.VK_9);
		put('a', KeyEvent.VK_A);
		put('&', KeyEvent.VK_AMPERSAND);
		put('*', KeyEvent.VK_ASTERISK);
		put('@', KeyEvent.VK_AT);
		put('b', KeyEvent.VK_B);
		put('`', KeyEvent.VK_BACK_QUOTE);
		put('\\', KeyEvent.VK_BACK_SLASH);
		put('{', KeyEvent.VK_BRACELEFT);
		put('}', KeyEvent.VK_BRACERIGHT);
		put('c', KeyEvent.VK_C);
		put('^', KeyEvent.VK_CIRCUMFLEX);
		put(']', KeyEvent.VK_CLOSE_BRACKET);
		put(':', KeyEvent.VK_COLON);
		put(',', KeyEvent.VK_COMMA);
		put('d', KeyEvent.VK_D);
		put('/', KeyEvent.VK_DIVIDE);
		put('$', KeyEvent.VK_DOLLAR);
		put('e', KeyEvent.VK_E);
		put('=', KeyEvent.VK_EQUALS);
		put('!', KeyEvent.VK_EXCLAMATION_MARK);
		put('f', KeyEvent.VK_F);
		put('g', KeyEvent.VK_G);
		put('>', KeyEvent.VK_GREATER);
		put('h', KeyEvent.VK_H);
		put('i', KeyEvent.VK_I);
		put('j', KeyEvent.VK_J);
		put('k', KeyEvent.VK_K);
		put('l', KeyEvent.VK_L);
		put('(', KeyEvent.VK_LEFT_PARENTHESIS);
		put('m', KeyEvent.VK_M);
		put('-', KeyEvent.VK_MINUS);
		put('n', KeyEvent.VK_N);
		put('#', KeyEvent.VK_NUMBER_SIGN);
		put('0', KeyEvent.VK_NUMPAD0);
		put('1', KeyEvent.VK_NUMPAD1);
		put('2', KeyEvent.VK_NUMPAD2);
		put('3', KeyEvent.VK_NUMPAD3);
		put('4', KeyEvent.VK_NUMPAD4);
		put('5', KeyEvent.VK_NUMPAD5);
		put('6', KeyEvent.VK_NUMPAD6);
		put('7', KeyEvent.VK_NUMPAD7);
		put('8', KeyEvent.VK_NUMPAD8);
		put('9', KeyEvent.VK_NUMPAD9);
		put('o', KeyEvent.VK_O);
		put('[', KeyEvent.VK_OPEN_BRACKET);
		put('p', KeyEvent.VK_P);
		put('.', KeyEvent.VK_PERIOD);
		put('+', KeyEvent.VK_PLUS);
		put('q', KeyEvent.VK_Q);
		put('\'', KeyEvent.VK_QUOTE);
		put('"', KeyEvent.VK_QUOTEDBL);
		put('r', KeyEvent.VK_R);
		put('s', KeyEvent.VK_S);
		put(';', KeyEvent.VK_SEMICOLON);
		put('/', KeyEvent.VK_SLASH);
		put(' ', KeyEvent.VK_SPACE);
		put('t', KeyEvent.VK_T);
		put('u', KeyEvent.VK_U);
		put('_', KeyEvent.VK_UNDERSCORE);
		put('v', KeyEvent.VK_V);
		put('w', KeyEvent.VK_W);
		put('x', KeyEvent.VK_X);
		put('y', KeyEvent.VK_Y);
		put('z', KeyEvent.VK_Z);
	};

	public MenuAction(String name, boolean enabled) { }
	public MenuAction(String name, Icon icon, boolean enabled) { }
	public MenuAction(String name, Character defaultBinding, boolean enabled) {
	public MenuAction(String name, Icon icon, Character defaultBinding, boolean enabled) {
		int mnemonic = 0;
		int bindingmask = ActionEvent.CTRL_MASK;

		// determine if name has '&'; if so remove it and set the mnemonic to the char after.
		
		// ...
		if (mnemonic) {
			this.putValue(Action.MNEMONIC_KEY, mnemonic);
		}

		// determine if the defaultBinding is capital; if so add shift mask and make it capital
		if (defaultBinding
		if (defaultBinding.isUpperCase()) {
			bindingMask |= ActionEvent.SHIFT_MASK;
		}
		this.putValue(Action.ACCELERATOR_KEY,
			KeyStroke.getKeyStroke(defaultBinding.toUpperCase(), bindingMask));
		this.setEnabled(enabled);
	
}

new MenuAction("&Open", 'o', false) {
	public void actionPerformed(ActionEvent e) {

		putValue(MNEMONIC_KEY, KeyEvent.VK_O);
		putValue(ACCELERATOR_KEY,
			KeyStroke.getKeyStroke('O', ActionEvent.CTRL_MASK));
		setEnabled(false);
	}
}
