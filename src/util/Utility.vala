public class Utility : GLib.Object {
    private static double pixels_per_second = 20;
    
    public static void set_color (Cairo.Context cr, Color color) {
        cr.set_source_rgba (color.r, color.g, color.b, color.a);
    }
    
    public static double seconds_to_track_pixels (double seconds_passed) {
        return seconds_passed * AudioContext.PIXELS_PER_SECOND;
    }
}
