public interface Exporter : GLib.Object {
    public abstract int export_wav (float *buffer, size_t size, string file_name);
    public abstract int export_audio_wav (AudioData data, string file_name);
}
