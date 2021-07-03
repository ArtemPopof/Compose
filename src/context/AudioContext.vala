public class AudioContext : GLib.Object {

    private static AudioInterface audio_interface;
    public const float SAMPLE_RATE = 44100;
    public const float SAMPLES_PER_PIXEL = 50.0f * SAMPLE_RATE / 2000.0f;
    public const float PIXELS_PER_SECOND = SAMPLE_RATE / SAMPLES_PER_PIXEL;
    public const int SAMPLES_PER_PREVIEW = (int) SAMPLES_PER_PIXEL;
    public const float PIXELS_PER_PREVIEW_SAMPLE = SAMPLES_PER_PREVIEW / SAMPLE_RATE * PIXELS_PER_SECOND;

    public AudioContext () {
        this.audio_interface = new JackAudioInterfaceImpl ();
    }
    
    public static AudioInterface get_audio_interface () {
        return audio_interface;
    }
}
