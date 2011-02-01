/**
 * A small program to extract all class files from a jar file
 * and write them to stdout in a way that can be used in vim.
 *
 * See http://www.fleiner.com/vim/syntax/java.vim
 */
import java.util.*;
import java.util.jar.*;

public class Highlight {
        protected Highlight parent;
        public String name;
        public String pack;
        protected boolean used=false;;
        
        public Map<String,Set<String>> cl=new HashMap<String,Set<String>>();
        public Map<String,Boolean> cu=new HashMap<String,Boolean>();

        public static final Boolean TRUE=new Boolean(true);
        public static final Boolean FALSE=new Boolean(false);

        public Highlight() {
                cl.put("C",new HashSet<String>());
                cl.put("X",new HashSet<String>());
                cl.put("E",new HashSet<String>());
                cl.put("R",new HashSet<String>());
                cu.put("C",FALSE);
                cu.put("X",FALSE);
                cu.put("E",FALSE);
                cu.put("R",FALSE);
        }

        public void use(String t) {
                used=true;
                cu.put(t,TRUE);
                if(parent!=null) parent.use(t);
        }

        public void add(String t,String cln) {
                use(t);
                cl.get(t).add(cln);
        }

        public String toString() {
                if(!used) return "";
                StringBuffer b=new StringBuffer();
                String[] nn=pack.split("\\.");
                String n="";
                String np="";
                String a="java_highlight";

                
                b.append("if exists(\"java_highlight_all\") ");
                for(String t:nn) {
                        a+="_"+t;
                        b.append(" || exists(\""+a+"\") ");
                        np=n;
                        n+=t.substring(0,1).toUpperCase()+t.substring(1);
                }

                b.append("\n  \" ").append(pack).append("\n");
                for(String nc:cl.keySet()) {
                        boolean used=cu.get(nc);
                        Set<String> h=cl.get(nc);
                        if(h.size()>0)
                                b.append("  syn keyword java").append(nc).append('_').append(n).append(' ').append(h.toString().replaceAll("[\\[\\]\\,]",""))
                                 .append("\n  syn cluster javaTop add=java").append(nc).append('_').append(n)
                                 .append("\n  syn cluster javaClasses add=java").append(nc).append('_').append(n)
                                 .append('\n');
                        if(used || h.size()>0)
                                b.append("  JavaHiLink java").append(nc).append('_').append(n).append(" java").append(nc).append('_').append(np).append('\n');

                }
                b.append("\nendif\n");
                return b.toString();
        }

        static Map<String,Highlight> pkg=new TreeMap<String,Highlight>();

        static protected Highlight get(String p) {
                Highlight s=pkg.get(p);
                if(s==null) {
                        s=new Highlight();
                        pkg.put(p,s);
                        s.pack=p;
                        if(p.indexOf('.')>0) s.parent=get(p.substring(0,p.lastIndexOf('.')));
                }
                return s;
        }

        static protected void workOn(Enumeration<JarEntry> e) throws Exception {
                while(e.hasMoreElements()) {
                        JarEntry  j=e.nextElement();
                        String n=j.toString();
                        n=n.replace('/','.').replaceAll(".class","");
                        // no com. classes
                        if(n.startsWith("META-INF") || n.startsWith("com.") || n.startsWith("sun.")) continue;
                        try {
                                Class c=Class.forName(n);
                                String p=n.substring(0,n.lastIndexOf('.'));
                                String name=n.substring(n.lastIndexOf('.')+1).replace('$','.');
                                String high=name;
                                if(high.indexOf('.')>=0) high=high.substring(high.lastIndexOf('.')+1);
                                if(high.matches("^[0-9]")) continue;

                                Highlight s=get(p);
                                while(true) {
                                        if(c==Object.class) {
                                                s.add("C",high);
                                                break;
                                        } else if(c==RuntimeException.class) {
                                                s.add("R",high);
                                                break;
                                        } else if(c==Error.class) {
                                                s.add("E",high);
                                                break;
                                        } else if(c==Throwable.class) {
                                                s.add("X",high);
                                                break;
                                        }
                                        c=c.getSuperclass();
                                }
                        } catch(Throwable ex) { }
                }
        }

        public static void printOut() {
                for(String p:pkg.keySet()) {
                        System.out.println(pkg.get(p));
                }
        }
                
        public static void main(String[] n) {
                if(n.length==0) {
                        System.err.println("usage: Highlight jarfile ...\n"+
                                           "Create vim syntax definitions to highlight all classes defined in the jar file.\n"+
                                           "Make sure that the jar files are also part of the classpath!\n"+
                                           "Note that this version of the program ignores all packages in com. and sun.\n");
                        System.exit(1);
                }
                for(String name:n) {
                        try { 
                                JarFile j=new JarFile(name);
                                workOn(j.entries());
                        } catch(Exception ex) {
                                System.err.println("Error: "+ex.getMessage());
                                ex.printStackTrace();
                        }
                }
                printOut();
        }
}
