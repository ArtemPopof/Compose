public class Utility : GLib.Object {
    public static void set_color (Cairo.Context cr, Color color) {
        cr.set_source_rgba (color.r, color.g, color.b, color.a);
    }
}
