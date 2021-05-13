public class Controller : GLib.Object, Transport {

    public enum State {
        IDLE,
        PLAYING,
        RECORD,
        PAUSED
    }
    
    private AudioInterface backend;
    
    private const int UPS = 30;
    
    private WorkingArea working_area;
    private double play_time;
    private ulong update_period;
    
    private bool initialized;

    public State state {get; set;}

    public Controller (AudioInterface backend, WorkingArea working_area) {
        this.backend = backend;
        this.working_area = working_area;
        state = State.IDLE;
        initialized = false;
        
        update_period = 1000000 / UPS;
    }
    
    ~Controller () {
        backend.close();
    }
    
    public void init () {
        initialized = true;
        
        backend.set_transport (this);
    }
    
    public void play () {
        validate ();
        state = State.PLAYING;
        
        play_time = 0;
        
        //start_ui_update_thread ();
    }
    
    private void start_ui_update_thread () {
        Thread.create<void> (ui_update_thread, false);
    }
    
    private void ui_update_thread () {
        // while (state == State.PLAYING || state == State.RECORD) {
        //     Thread.usleep (update_period);
        //     
        //     working_area.pointer.move (update_period); 
        //     working_area.queue_draw ();
        // }
    }
    
    public void stop () {
        if (state == State.RECORD) {
            var data = backend.stop_record ();
            print ("recording complete, recorded %u bytes\n", (uint) (data.size * sizeof (float)));
        }
        
        state = State.IDLE;
    }
    
    public void record () {
        validate ();
        state = State.RECORD;
        
        backend.record ();
        print ("recording... \n");
        
        working_area.pointer.reset ();
        working_area.queue_draw ();
                
        //start_ui_update_thread ();
    }
    
    public void pause () {
        validate ();
        state = State.PAUSED;
    }
    
    private void validate () {
        if (!initialized) {
            printerr ("Init controller before using it\n");
            Process.exit (1);
        }
    }
    
    public void move_transport (ulong frames) {
        var sample_rate = backend.get_sample_rate ();
        
        double seconds_passed = frames / (double) sample_rate;
        
        working_area.pointer.move (seconds_passed);
        
        working_area.queue_draw ();
    }
    
    public void samples_preview (int samples_per_preview, float[] sample_previews) {
        // now we assume that this func is called with the same frame count
        var current_transport_pos = working_area.pointer.current_position;
        
        working_area.get_track (0).sample_preview (Utility.seconds_to_track_pixels (current_transport_pos), sample_previews);
    }

}
