public class AudioData : GLib.Object {
    public float *buffer { get; set; }
    public size_t size { get; set; }
    
    public AudioData (float *buffer, size_t length) {
        this.buffer = buffer;
        this.size = length;
    }
    
    ~AudioData () {
        free (buffer);
    }
}
