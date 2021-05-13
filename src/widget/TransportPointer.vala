using Gtk;

public class TransportPointer : DrawableObject, GLib.Object {

    private const double COLOR_R = 0.8f;
    private const double COLOR_G = 0.8f;
    private const double COLOR_B = 0.75f;
    
    private const double START_OFFSET = 5;

    public double current_position {get; set;}
    
    public TransportPointer () {
        current_position = 0;
    }

    public bool draw (Cairo.Context cr, double canvas_width, double canvas_height, double x, double y) {
        cr.save ();
        
        cr.set_source_rgb (COLOR_R, COLOR_G, COLOR_B);
        cr.set_line_width (1.3);
        
        cr.move_to (START_OFFSET + Utility.seconds_to_track_pixels (current_position), 0);
        cr.line_to (START_OFFSET + Utility.seconds_to_track_pixels (current_position), canvas_height);
        
        cr.stroke ();
        
        cr.restore ();
        
        return false;
    }
    
    public void move (double sec) {
        current_position = current_position + sec;
    }
    
    public void reset () {
        current_position = 0;
    }
}
