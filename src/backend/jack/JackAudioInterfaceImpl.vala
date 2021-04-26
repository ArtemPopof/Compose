using Jack;

public class JackAudioInterfaceImpl : GLib.Object, AudioInterface {
    
    public int init () {
        print ("initialising jack backend...");
        
        Status status;
        Client client = Client.open ("Compose", Options.NullOption, out status);
        if (client == null) {
		    print ("jack_client_open() failed, status = 0x%2.0x\n", status);
		    
		    if ((status & Status.ServerFailed) != 0) {
			    print ("Unable to connect to JACK server\n");
		    }
		    
		    return 1;
	    }
	    
        print ("Connected to JACK server");
    
        return 0;
    }
    
    public void play (AudioData clip, bool looped) {
        
    }
    
    public void stop (AudioData clip) {
        
    }
    
    public void record () {
        
    }
    
    public AudioData stop_record () {
        return null;
    }
    
    public void close () {
        
    }
}
