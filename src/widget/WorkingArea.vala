using Gtk;

public class WorkingArea : DrawingArea {

    private const double BACKGROUND_COLOR_R = 0.2;
    private const double BACKGROUND_COLOR_G = 0.2;
    private const double BACKGROUND_COLOR_B = 0.2;
    
    public TransportPointer pointer {get; set;}
    
    private Track[] tracks;
    
    public WorkingArea () {
        add_events (Gdk.EventMask.POINTER_MOTION_MASK);
        
        pointer = new TransportPointer ();
        
        tracks = new Track[10];
        for (int i = 0; i < tracks.length; i++) {
            tracks[i] = new Track();
        }
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
            
            var track_index = track_y / track_size;
            tracks[track_index].draw (cr, width / 2 - 10, track_size - 10, 5, track_y + 5);
        }
        
        // draw components 
        pointer.draw (cr, width, height, 0, 0);
        
        return false;
    }
    
    public Track get_track (int index) {
        return tracks[index];
    }
    
}
