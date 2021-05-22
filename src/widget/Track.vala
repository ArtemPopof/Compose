using Gee;

public class Track : DrawableObject, GLib.Object {

    private const int MAX_PREVIEW_SAMPLES = 100000;

    private const Color BACKGROUND_COLOR = {0.8, 0.6, 0.6, 0.9};
    private const Color STROKE_COLOR = {0.8, 0.7, 0.7, 0.4};
    private const Color PREVIEW_COLOR = {0, 0, 0, 0.4};
    
    private double amp = 5000;
    private double preview_offset = 50;
    
    private float[] samples_preview_data;
    private int preview_samples_count = 0;
    
    private AudioData audio_data {get; set;}
    public TrackControls controls_widget {get; set;}
        
    public Track (Controller controller) {
        samples_preview_data = new float[MAX_PREVIEW_SAMPLES];
        
        controls_widget = new TrackControls (controller);
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
        
        var pixels_per_preview_sample = AudioContext.PIXELS_PER_PREVIEW_SAMPLE;
        
         //print ("map size: %f\n", samples_preview_data[0]);
        // print ("map[last]: %f\n", samples_preview_data[preview_samples_count - 1]);
        
        var center = y + canvas_height / 2;
                    
        for (int i = 0; i < preview_samples_count; i++) {
            var sample_x = x + i * pixels_per_preview_sample;
            var sample_y = center - samples_preview_data[i] * amp;
            //print ("sample_x: %f\n", sample_x);
            //print ("sample_y: %f\n", sample_y);
            
            //print ("value: %f\n", entry.value);
            cr.move_to (sample_x, center);
            cr.line_to (sample_x, sample_y);
        }
                
        cr.set_line_width (1.0);
        cr.stroke ();
    }
    
    public void sample_preview (double track_position_pixels, float[] sample_previews) {
        void * position = ((float *)samples_preview_data) + preview_samples_count;
        preview_samples_count += sample_previews.length;
        Memory.copy (position, sample_previews, sizeof (float) * sample_previews.length);
    }
}
