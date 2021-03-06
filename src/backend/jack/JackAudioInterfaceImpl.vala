using Jack;

public class JackAudioInterfaceImpl : GLib.Object, AudioInterface {

    private Port output_port1;
    private Port output_port2;
    private Port input_port;
    private Client client;
    
    private double twopi_over_sr;
    private double m_amp = 0.1;
    private double m_freq = 200;
    private ulong m_time = 0;
    
    public float[] buffer = new float[1024 * 1024];
    private ulong last_buffer_pos;
    
    private void shutdown () {
    }
    
    private int process (NFrames nframes) {
        float *out1 = (float *) output_port1.get_buffer (nframes);
        float *out2 = (float *) output_port2.get_buffer (nframes);
        
        float *input = (float *) input_port.get_buffer (nframes);
        
        //SUPER LOUD SINE
        // float val;
        // for (int i = 0; i < nframes; i++) {
        //     if (last_buffer_pos >= buffer.length - 10000) {
        //         print ("Buffer full, recording complete\n");
        //         new SndFileExporter ().export_wav ((float *) buffer, last_buffer_pos * sizeof (float), "test.wav");
        //         last_buffer_pos = 0;
        //         return 0;
        //     }
        //     val = (float) (m_amp * GLib.Math.sin (m_freq * m_time * twopi_over_sr));
        //     
        //     buffer[last_buffer_pos + i] = val;
        //     
        //     this.m_time++;
        // }
        
        // monitor input
        for (int i = 0; i < nframes; i++) {
            if (last_buffer_pos >= buffer.length - 100) {
                print ("Buffer full, recording complete\n");
                new SndFileExporter ().export_wav ((float *) buffer, last_buffer_pos * sizeof (float), "test.wav");
                last_buffer_pos = 0;
                return 0;
            }
            buffer[last_buffer_pos + i] = input[i];
        }
        
        last_buffer_pos += nframes;
        
        print ("Buffer position: %u\n", (uint) last_buffer_pos);
        
        return 0;
    }
    
    public int init () {
        print ("Initialising jack backend...\n");
        
        last_buffer_pos = 0;
        
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
        input_port = client.port_register ("input", Jack.DefaultAudioType, PortFlags.IsInput, 0);
        
        if (output_port1 == null || output_port2 == null || input_port == null) {
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
        
        string[] ports_array = pointer_to_array (ports, 2);
        
        print ("\nAvailable playback ports: \n");
        for (int i = 0; i < ports_array.length; i++) {
            if (ports_array[i] == null) break;
            print ("%d | %s\n", i, ports_array[i]);
        }
        print ("------------------\n");
        
        if (client.connect ("Compose:output1", ports_array[0]) != 0) {
            print ("Cannot connect output ports\n");
        }
        if (client.connect ("Compose:output2", ports_array[1]) != 0) {
            print ("Cannot connect output ports\n");
        }
        
        print ("Output ports connected\n");
        
        // CONNECT INPUT
        
        ports = client.get_ports (null, null, PortFlags.IsPhysical | PortFlags.IsOutput);
        
        if (ports == null) {
            print ("No physical recording ports\n");
            return 1;
        }
        
        ports_array = pointer_to_array (ports, 2);
        
        print ("\nAvailable recording ports: \n");
        for (int i = 0; i < ports_array.length; i++) {
            if (ports_array[i] == null) break;
            print ("%d | %s\n", i, ports_array[i]);
        }
        print ("------------------\n");
        
        // var name = output_port1.name ();
        // print ("port: %s\n", name);
        // 
        if (client.connect (ports_array[0], "Compose:input") != 0) {
            print ("Cannot connect input port\n");
            return 1;
        }
        
        print ("Input port connected\n");
        
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
