using PulseAudio;
    
public class PulseAudioInterfaceImpl : GLib.Object, AudioInterface {

    private PulseAudio.GLibMainLoop loop;
    private PulseAudio.Context playback_context;
    private PulseAudio.Context record_context;
    private Context.Flags cflags;
    private PulseAudio.SampleSpec spec;
    private PulseAudio.Stream.BufferAttr attr;
    private double twopi_over_sr;
    private double m_amp = 0.3;
    private double m_freq = 1760;
    private ulong m_time = 0;
    
    private ulong last_buffer_pos = 0;
    private ulong playback_buffer_pos = 0;

    public int16[] buffer = new int16[1 * 1024 * 1024];
    private bool recording;
    private bool playing;
    
    private PulseAudio.Stream playback_stream;
    private PulseAudio.Stream record_stream;
    
    public int init () {
        last_buffer_pos = 0;
        recording = false;
        playing = false;
        
        this.spec = PulseAudio.SampleSpec () {
            format = PulseAudio.SampleFormat.S16LE,
            channels = 2,
            rate = 44100
        };
        
        twopi_over_sr = (2.0 * Math.PI) / (double) spec.rate;
        
        this.loop = new PulseAudio.GLibMainLoop ();
        this.playback_context = new PulseAudio.Context (loop.get_api (), null);
        this.record_context = new PulseAudio.Context (loop.get_api (), null);
        this.cflags = Context.Flags.NOFAIL;
        this.playback_context.set_state_callback (this.set_state_playback);
        this.record_context.set_state_callback (this.set_state_record);
        
        // connect the playback context
        if (this.playback_context.connect (null, this.cflags, null) < 0) {
            print ("pa_context_connect for playback failed: %s\n", PulseAudio.strerror (playback_context.errno ()));
        }
        
        // connect the record context
        if (this.record_context.connect (null, this.cflags, null) < 0) {
            print ("pa_context_connect for record failed: %s\n", PulseAudio.strerror (record_context.errno ()));
        }
        
        record_context.get_source_info_list(source_list_callback);
        
        return 0;
    }
    
    private void source_list_callback (Context context, SourceInfo? sources, int eol) {
        print ("received source list\n");
    }
    
    private void set_state_playback (Context context) {
        set_state_callback (context, true);
    }
    
    private void set_state_record (Context context) {
        set_state_callback (context, false);
    }
        
    private void set_state_callback (Context context, bool playback) {
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
            stream.set_read_callback (this.read);
            stream.set_overflow_callback (this.stream_overflow);
            stream.set_underflow_callback (this.stream_underflow);
            
            if (playback) {
                playback_stream = stream;
            } else {
                record_stream = stream;
            }
            
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
            
            if (playback) {
                int error = stream.connect_playback (null, attr, flags, null, null);
                if (error != 0) {
                    print ("connect_playback returned %s\n", error.to_string());
                    print (": pa_stream_connect_playback () failed: %s\n", PulseAudio.strerror(context.errno()));
                }
            } else {
                int error = stream.connect_record (null, attr, flags);
                print ("connected %d\n", error);
                if (error != 0) {
                    print ("connect_record returned %s\n", error.to_string());
                    print (": pa_stream_connect_record () failed: %s\n", PulseAudio.strerror(context.errno()));
                }
            }

        }   
    }
    
    private void read (Stream stream, size_t nbytes) {
        if (!recording) return;

        //stdout.printf ("recording %u bytes\n", (uint) nbytes);
                
        if (last_buffer_pos + nbytes >= buffer.length / sizeof (int16)) {
            print ("done with recording\n");
            recording = false;
            playing = true;
            playback_buffer_pos = 0;
            new SndFileExporter ().export_wav ((void *) buffer, last_buffer_pos * sizeof (int16), "test.wav");
            return;
        }
        
        void* current_buffer_pos = (void *) (buffer[last_buffer_pos]);
        
        if (stream.peek (out current_buffer_pos, out nbytes) < 0) {
            print ("failed to peek %s", PulseAudio.strerror(record_context.errno ()));
            return;
        }
        if (stream.drop () < 0) {
            print ("failed to drop %s", PulseAudio.strerror(record_context.errno ()));
            return;
        }
        
        print ("read %u bytes\n", (uint) nbytes);
        for (int i = 0; i < nbytes; i++) {
            print ("%d", buffer[last_buffer_pos + i]);
        }
        print ("\n");
        print ("current buff pos: %u kb\n", (uint) (last_buffer_pos / 1024 * 2));
        
        last_buffer_pos += nbytes / sizeof (int16);
    }
    
    private void write (Stream stream, size_t nbytes) {
        //print ("playing %u bytes\n", (uint) nbytes);
        if (!playing) {
                uint len = (uint) (nbytes / sizeof (uint16));
                int16[] data = new int16[len];
                
                // white noise generator
                // for (int i = 0; i < len; i++) {
                //     data[i] = (int16) Random.int_range (-32768, 32767);
                // }
                // 
                //sine wave generator
                uint samps = 0;
                for (uint i = 0; i < len; i += spec.channels) {
                    int16 val = (int16) (32767.0 * m_amp * GLib.Math.sin (m_freq * m_time * twopi_over_sr));
                    for (uint j = 0; j < spec.channels; j++) {
                        buffer[i + j] = val;
                        samps++;
                    }
                    this.m_time++;
                }
                
            stream.write ((void *) buffer, sizeof (int16) * data.length);
            
            return;
        }
        
        print ("playing %u bytes\n", (uint) nbytes);
        
        if (last_buffer_pos <= nbytes / sizeof (int16)) {
            print ("buffer empty");
            playing = false;
            return;
        }
        
        size_t len = nbytes / sizeof (int16);
        if (len > last_buffer_pos) {
            len = last_buffer_pos;
        }
        
        
        void* buffer_pos = (void *)(&buffer[playback_buffer_pos]);
        
        stream.write (buffer_pos, len * sizeof (int16));
        
        playback_buffer_pos += len;
        last_buffer_pos -= len;
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
