using Gtk;

public class WorkingArea : DrawingArea {

    private const double BACKGROUND_COLOR_R = 0.3;
    private const double BACKGROUND_COLOR_G = 0.3;
    private const double BACKGROUND_COLOR_B = 0.3;
    
    private TransportPointer pointer;
    
    public static WorkingArea instance;
    
    public WorkingArea () {
        add_events (Gdk.EventMask.POINTER_MOTION_MASK);
        
        pointer = new TransportPointer ();
        
        instance = this;
    }

    public override bool draw (Cairo.Context cr) {
        var width = get_allocated_width ();
        var height = get_allocated_height ();
        
        var track_size = height / 3;
        
        cr.set_source_rgb (BACKGROUND_COLOR_R, BACKGROUND_COLOR_G, BACKGROUND_COLOR_B);
        cr.rectangle (0, 0, width, height);
        cr.fill ();
        
        cr.set_line_width (2);
        cr.set_source_rgb (0.4, 0.4, 0.4);
        for (int track_y = 0; track_y + track_size < height + 1; track_y += track_size) {
            cr.move_to (0, track_y);
            cr.line_to (width, track_y);
            cr.stroke ();
        }
        
        // draw components 
        pointer.draw (cr, width, height);
        
        return false;
    }
}
