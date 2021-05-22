public class TrackControls : Gtk.Box {

    private Controller controller;

    public TrackControls (Controller controller) {
        orientation = HORIZONTAL;
        spacing = 5;
        controller = controller;
        
        add (create_record_button ());
        add (new Gtk.Button.with_label (_("Play")));
        add (create_stop_button ());

        vexpand = true;
    }
    
    private Gtk.Button create_record_button () {
        Gtk.Button button = new Gtk.Button.with_label (_("Record"));
        button.clicked.connect (() => {
            controller.record ();
        });
        
        return button;
    }
    
    private Gtk.Button create_stop_button () {
        Gtk.Button button = new Gtk.Button.with_label (_("Stop"));
        button.clicked.connect (() => {
            controller.stop ();
        });
        
        return button;
    }
}
