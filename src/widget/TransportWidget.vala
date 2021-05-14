public class TransportWidget : Gtk.Grid {

    private Controller controller;
    
    private Gtk.Button play_button;
    private Gtk.Button record_button;
    private Gtk.Button stop_button;
    
    private Gtk.Image play_image;
    private Gtk.Image record_image;
    private Gtk.Image stop_image;
    private Gtk.Image play_active_image;
    private Gtk.Image record_active_image;
    private Gtk.Image stop_active_image;
    
    public TransportWidget(Controller controller) {
        this.controller = controller;

        create_controls ();
    }
    
    private void create_controls () {
        record_image = new Gtk.Image.from_file ("icons/record.png");
        play_image = new Gtk.Image.from_file ("icons/play.png"); 
        stop_image = new Gtk.Image.from_file ("icons/stop.png");
        record_active_image = new Gtk.Image.from_file("icons/record_active.png");
        play_active_image = new Gtk.Image.from_file("icons/play_active.png");
        stop_active_image = new Gtk.Image.from_file("icons/stop_active.png");
        
        play_button = new Gtk.Button ();
        record_button = new Gtk.Button ();
        stop_button = new Gtk.Button ();
        
        update_buttons ();
        
        play_button.clicked.connect (() => {
            if (controller.state == Transport.State.PLAYING) {
                return;
            }
            
            controller.play ();
            update_buttons ();
        });
        
        record_button.clicked.connect (() => {
            if (controller.state == Transport.State.RECORD) {
                return;
            }
            
            controller.record ();
            update_buttons ();
        });
        
        
        orientation = Gtk.Orientation.HORIZONTAL; 
        column_spacing = 0;
        set_column_spacing (0);
        
        attach (play_button, 0, 0);
        attach (stop_button, 1, 0);
        attach (record_button, 2, 0);
    }
    
    private void update_buttons () {
        var state = controller.state;
        
        if (state == Transport.State.IDLE) {
            play_button.set_image (play_image);
            record_button.set_image (record_image);
            stop_button.set_image (stop_image);
        }
        if (state == Transport.State.PLAYING) {
            play_button.set_image (play_active_image);
            record_button.set_image (record_image);
            stop_button.set_image (stop_image);
        }
        if (state == Transport.State.RECORD) {
            play_button.set_image (play_image);
            record_button.set_image (record_active_image);
            stop_button.set_image (stop_image);
        }
    }
    
 
    
}
