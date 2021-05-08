public interface AudioInterface : GLib.Object {
    
    public abstract int init ();
    
    public abstract void play (AudioData clip, bool looped);
    public abstract void stop (AudioData clip);
    
    public abstract void record ();
    public abstract AudioData stop_record ();  
    
    public abstract void close (); 
    
    public abstract void set_transport (Transport transport);
    
    public abstract uint get_sample_rate ();
}
