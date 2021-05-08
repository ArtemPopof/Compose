public class Controller : GLib.Object {

    public enum State {
        IDLE,
        PLAYING,
        RECORD,
        PAUSED
    }
    
    private AudioInterface backend;
    
    private const int UPS = 30;
    
    private TransportPointer pointer;
    private WorkingArea working_area;
    private double play_time;
    private ulong update_period;

    public State state {get; set;}

    public Controller (AudioInterface backend) {
        this.backend = backend;
        state = State.IDLE;
        
        update_period = 1000000 / UPS;
    }
    
    ~Controller () {
        backend.close();
    }
    
    public void init () {
        pointer = TransportPointer.instance;
        working_area = WorkingArea.instance;
    }
    
    public void play () {
        validate ();
        state = State.PLAYING;
        
        play_time = 0;
        
        start_ui_update_thread ();
    }
    
    private void start_ui_update_thread () {
        Thread.create<void> (ui_update_thread, false);
    }
    
    private void ui_update_thread () {
        while (state == State.PLAYING || state == State.RECORD) {
            Thread.usleep (update_period);
            
            pointer.move (update_period); 
            working_area.queue_draw ();
        }
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
        
        start_ui_update_thread ();
    }
    
    public void pause () {
        validate ();
        state = State.PAUSED;
        
    }
    
    private void validate () {
        if (pointer == null) {
            printerr ("Init controller before using it\n");
            Process.exit (1);
        }
    }

}
