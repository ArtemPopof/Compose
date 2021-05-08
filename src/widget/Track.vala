using Gee;

public class Track : DrawableObject, GLib.Object {

    private const Color BACKGROUND_COLOR = {0.8, 0.4, 0.4, 0.7};
    private const Color STROKE_COLOR = {0.6, 0.2, 0.2, 1};
    private const Color PREVIEW_COLOR = {0.7, 0.57, 0, 0.9};
    
    private HashMap<double?, double?> samples_preview_data;
        
    public Track () {
        samples_preview_data = new HashMap<double?, double?> ();
    }
    
    
    public bool draw (Cairo.Context cr, double canvas_width, double canvas_height, double x, double y) {
        cr.save ();
        
        // cr.set_source_rgba (BACKGROUND_R, BACKGROUND_G, BACKGROUND_B, BACKGROUND_A);
        // cr.set_line_width (1);
        // cr.rectangle(x, y, canvas_width, canvas_height);
        // cr.fill ();
        // cr.set_source_rgba (BACKGROUND_R - 0.1, BACKGROUND_G - 0.05, BACKGROUND_B - 0.05, 0);
        // cr.stroke ();
        
        draw_rounded_rectangle (cr, BACKGROUND_COLOR, STROKE_COLOR, x, y, canvas_width, canvas_height, 8);
        
        draw_preview (cr, canvas_width - 5, canvas_height - 5, x + 10, y + 10);
        
        cr.restore ();
        return false;
    }
    
    private void draw_rounded_rectangle (Cairo.Context cr, Color fill, Color stroke, double x, double y, double width, double height, double radius) {
        double degrees = Math.PI / 180.0;

        cr.new_sub_path ();
        cr.arc (x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees);
        cr.arc (x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees);
        cr.arc (x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees);
        cr.arc (x + radius, y + radius, radius, 180 * degrees, 270 * degrees);
        cr.close_path ();

        cr.set_source_rgba (BACKGROUND_COLOR.r, BACKGROUND_COLOR.g, BACKGROUND_COLOR.b, BACKGROUND_COLOR.a);
        cr.fill_preserve ();
        cr.set_source_rgba (STROKE_COLOR.r, STROKE_COLOR.g, STROKE_COLOR.b, STROKE_COLOR.a);
        cr.set_line_width (2.0);
        cr.stroke ();
    }
    
    private void draw_preview (Cairo.Context cr, double canvas_width, double canvas_height, double x, double y) {
        Utility.set_color (cr, PREVIEW_COLOR);
        
        cr.new_sub_path ();
        cr.move_to (0, 0);
        for (int i = 0; i < samples_preview_data.size; i++) {
            var sample_x = x + i * 5;
            var sample_y = y + canvas_height / 2;
            
            cr.line_to (sample_x, sample_y);
        }
        cr.close_path ();
        
        cr.set_line_width (1.0);
        cr.stroke ();
    }
    
    public void sample_preview (double track_position, double sample_level) {
        samples_preview_data.set (track_position, sample_level);
    }
}
