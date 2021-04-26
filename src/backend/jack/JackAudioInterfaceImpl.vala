using Jack;

public class JackAudioInterfaceImpl : GLib.Object, AudioInterface {

    private Port output_port1;
    private Port output_port2;
    private Client client;
    
    private double twopi_over_sr;
    private const uint32 max_int32 = 2147483647;
    private double m_amp = 0.3;
    private double m_freq = 440;
    private ulong m_time = 0;
    
    private void shutdown () {
    }
    
    private int process (NFrames nframes) {
        print ("processing %u frames\n", (uint) nframes);
        
        int32 *out1 = (int32 *) output_port1.get_buffer (nframes);
        int32 *out2 = (int32 *) output_port2.get_buffer (nframes);
        
        int32 val;
        for (int i = 0; i < nframes; i++) {
            val = (int32) (max_int32 * m_amp * GLib.Math.sin (m_freq * m_time * twopi_over_sr));
            
            out1[i] = val;
            out2[i] = val;
         
            this.m_time++;
        }
        
        return 0;
    }
    
    public int init () {
        print ("Initialising jack backend...\n");
        
        Status status;
        client = Client.open ("Compose", Options.NullOption, out status);
        if (client == null) {
		    print ("jack_client_open() failed, status = 0x%2.0x\n", status);
		    
		    if ((status & Status.ServerFailed) != 0) {
			    print ("Unable to connect to JACK server\n");
		    }
		    
		    return 1;
	    }
	    
	    if ((status & Status.ServerStarted) != 0) {
	        print ("Started JACK server\n");
        }
        
        print ("Connected to JACK server\n");
        
        client.set_process_callback (process);
        client.on_shutdown (shutdown);
        
        output_port1 = client.port_register ("output1", Jack.DefaultAudioType, PortFlags.IsOutput, 0);
        output_port2 = client.port_register ("output2", Jack.DefaultAudioType, PortFlags.IsOutput, 0);
        //input_port = client.port_register ("input", Jack.DefaultAudioType, PortFlags.IsInput, 0);
        
        if (output_port1 == null || output_port2 == null) {
            print ("Can't register JACK ports \n");
            return 1;
        }
        
        // process () callback will start running now
        if (client.activate () != 0) {
            print ("Failed to activate client\n");
            return 1;
        }
        
        string* ports = client.get_ports (null, null, PortFlags.IsPhysical | PortFlags.IsInput);
        
        if (ports == null) {
            print ("No physical playback ports\n");
            return 1;
        }
        
        string[] ports_array = pointer_to_array (ports, 10);
        
        print ("\nAvailable ports: \n");
        for (int i = 0; i < ports_array.length; i++) {
            if (ports_array[i] == null) break;
            print ("%d | %s\n", i, ports_array[i]);
        }
        print ("------------------\n");
        
        if (client.connect (, ports_array[0]) != 0) {
            print ("Cannot connect output ports\n");
        }
        if (client.connect (output_port2.name (), ports_array[1]) != 0) {
            print ("Cannot connect output ports\n");
        }
        
        NFrames sample_rate = client.get_sample_rate ();
        twopi_over_sr = (2.0 * Math.PI) / (double) sample_rate;
        
        print ("Jack initializing complete, sample rate: %u\n", sample_rate);

        return 0;
    }
    
    unowned string[] pointer_to_array (string* p, uint length) {
        return ((string[]) p)[0:length];
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
