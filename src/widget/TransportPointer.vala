using Gtk;

public class TransportPointer : DrawableObject, GLib.Object {

    private const double COLOR_R = 0.8f;
    private const double COLOR_G = 0.8f;
    private const double COLOR_B = 0.75f;
    
    private const double START_OFFSET = 5;

    private double pixels_per_second = 20;
    private double current_position;
    
    public static TransportPointer instance;
    
    public TransportPointer () {
        current_position = 0;
        
        instance = this;
    }

    public bool draw (Cairo.Context cr, double canvas_width, double canvas_height) {
        cr.save ();
        
        cr.set_source_rgb (COLOR_R, COLOR_G, COLOR_B);
        cr.set_line_width (1.3);
        
        cr.move_to (START_OFFSET + current_position * pixels_per_second, 0);
        cr.line_to (START_OFFSET + current_position * pixels_per_second, canvas_height);
        
        cr.stroke ();
        
        cr.restore ();
        
        return false;
    }
    
    public void move (ulong usec_delta) {
        current_position = usec_delta / 1000000.0;
    }
}
