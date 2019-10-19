public class AddFuns {
  public static int getCharInt(String str,int i) {
    return (int)str.charAt(--i);
  }

  public static int getCharInt(String str) {
    return (int)str.charAt(0);
  }
  
  public static String getIntChar(int str) {
    return String.valueOf((char)str);
  }

}