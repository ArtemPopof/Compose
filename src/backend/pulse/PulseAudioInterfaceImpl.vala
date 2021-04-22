using PulseAudio;

public class PulseAudioInterfaceImpl : GLib.Object, AudioInterface {

    private PulseAudio.GLibMainLoop loop;
    private PulseAudio.Context context;
    private Context.Flags cflags;
    private PulseAudio.SampleSpec spec;
    private PulseAudio.Stream.BufferAttr attr;
    private double twopi_over_sr;
    private double m_amp = 0.3;
    private double m_freq = 1760;
    private ulong m_time = 0;
    
    private ulong last_buffer_pos = 0;
    public int16 buffer[100 * 1024 * 1024];
    private bool recording = false;
    
    public int init () {
        last_buffer_pos = 0;
        recording = false;
        
        this.spec = PulseAudio.SampleSpec () {
            format = PulseAudio.SampleFormat.S16LE,
            channels = 2,
            rate = 44100
        };
        
        twopi_over_sr = (2.0 * Math.PI) / (double) spec.rate;
        
        this.loop = new PulseAudio.GLibMainLoop ();
        this.context = new PulseAudio.Context (loop.get_api (), null);
        this.cflags = Context.Flags.NOFAIL;
        this.context.set_state_callback (this.set_state_callback);
        
        // connect the context
        if (this.context.connect (null, this.cflags, null) < 0) {
            print ("pa_context_connect () failed: %s\n", PulseAudio.strerror (context.errno ()));
        }
        
        return 0;
    }
    
    private void set_state_callback (Context context) {
        Context.State state = context.get_state ();
        if (state == Context.State.UNCONNECTED) { print("state UNCONNECTED\n"); }
        if (state == Context.State.CONNECTING) { print("state CONNECTING\n"); }
        if (state == Context.State.AUTHORIZING) { print("state AUTHORIZING,\n"); }
        if (state == Context.State.SETTING_NAME) { print("state SETTING_NAME\n"); }
        if (state == Context.State.READY) { print("state READY\n"); }
        if (state == Context.State.FAILED) { print("state FAILED,\n"); }
        if (state == Context.State.TERMINATED) { print("state TERMINATED\n"); }
                
        if (state == Context.State.READY) {
            this.attr = PulseAudio.Stream.BufferAttr ();
            size_t fragment_size = 0;
            size_t n_fragments = 0;
            Stream.Flags flags = Stream.Flags.INTERPOLATE_TIMING | Stream.Flags.AUTO_TIMING_UPDATE | Stream.Flags.EARLY_REQUESTS;
            
            PulseAudio.Stream stream = new PulseAudio.Stream (context, "", this.spec);
            stream.set_write_callback (this.write);
            stream.set_overflow_callback (this.stream_overflow);
            stream.set_underflow_callback (this.stream_underflow);
            
            PulseAudio.Stream record_stream = new PulseAudio.Stream (context, "", this.spec);
            stream.set_read_callback (this.read);
            stream.set_overflow_callback (this.stream_overflow);
            stream.set_underflow_callback (this.stream_underflow);
            
            size_t frame_size = spec.frame_size ();
            if ((fragment_size % frame_size) == 0 && n_fragments >= 2 && fragment_size > 0) {
                print ("something went wrong \n");
                return;
            }
            
            // Number of fragments set?
            if (n_fragments < 2) {
                if (fragment_size > 0) {
                    n_fragments = (spec.bytes_per_second() / 2 / fragment_size);
                    if (n_fragments < 2)
                        n_fragments = 2;
                } else
                n_fragments = 12;
            }
            
            // Fragment size set?
            if (fragment_size <= 0) {
                fragment_size = spec.bytes_per_second() / 2 / n_fragments;
                if (fragment_size < 1024)
                    fragment_size = 1024;
            }

            print("fragment_size: %s, n_fragments: %s, fs: %s\n", fragment_size.to_string(),    n_fragments.to_string(), frame_size.to_string());
            
            attr.maxlength = (uint32) (fragment_size * (n_fragments + 1));
            attr.tlength = (uint32) (fragment_size * n_fragments);
            attr.prebuf = (uint32) fragment_size;
            attr.minreq = (uint32) fragment_size;
            
            int error = record_stream.connect_record (null, attr, flags);
            if (error != 0) {
                print ("connect_record returned %s\n", error.to_string());
                print (": pa_stream_connect_record () failed: %s\n", PulseAudio.strerror(context.errno()));
            }
            
            error = stream.connect_playback (null, attr, flags, null, null);
            if (error != 0) {
                print ("connect_playback returned %s\n", error.to_string());
                print (": pa_stream_connect_playback () failed: %s\n", PulseAudio.strerror(context.errno()));
            }
        }   
    }
    
    private void read (Stream stream, size_t nbytes) {
        stdout.printf ("recording %u bytes\n", (uint) nbytes);
        if (!recording) return;
        
        void* current_buffer_pos = (void *) (&buffer[last_buffer_pos]);
        
        stream.peek (out current_buffer_pos, out nbytes);
        
        last_buffer_pos += nbytes / sizeof (uint16);
    }
    
    private void write (Stream stream, size_t nbytes) {
        uint len = (uint) (nbytes / sizeof (uint16));
        int16[] data = new int16[len];
        
        // // white noise generator
        // for (int i = 0; i < len; i++) {
        //     data[i] = (int16) Random.int_range (-32768, 32767);
        // }
        
        // sine wave generator
        uint samps = 0;
        for (uint i = 0; i < len; i += spec.channels) {
            int16 val = (int16) (32767.0 * m_amp * GLib.Math.sin (m_freq * m_time * twopi_over_sr));
            for (uint j = 0; j < spec.channels; j++) {
                data[i + j] = val;
                samps++;
            }
            this.m_time++;
        }
        
        stream.write ((void *) data, sizeof (int16) * data.length);
    }
    
    private void stream_overflow(Stream stream) {
        print("AudioDevice: stream overflow...\n");
    }
    
    private void stream_underflow(Stream stream) {
        print("AudioDevice: stream underflow...\n");
    }


    public void play (AudioData clip, bool looped) {
        
    }
    
    public void stop (AudioData clip) {
        
    }
    
    public void record () {
        this.recording = true;
    }
    
    public AudioData stop_record () {
        return null;
    }
    
    public void close () {
        
    }
}
