using Gee;
    
public class ContextProperties : GLib.Object {

    private static const string TRANSPORT_POINTER_POSITION = "transport_position";

    private HashMap<string, string> properties;
    
    public ContextProperties () {
        properties = new HashMap<string, string> ();
        
        // init project state
        //properties.put (TRANSPORT_POINTER_POSITION, "0");
    }
    
}
