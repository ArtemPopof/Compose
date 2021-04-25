public interface Exporter : GLib.Object {
    public abstract int export_wav (int16 *buffer, size_t size, string file_name);
}
