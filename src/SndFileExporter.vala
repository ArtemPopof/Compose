using Sndfile;

public class SndFileExporter : GLib.Object, Exporter {
    
    public int export_wav (void *buffer, size_t size, string file_name) {
        Info info = {};
        info.samplerate = 44100;
        info.channels = 2;
        info.format = Format.WAV | Format.PCM_16;
        
        Sndfile.File file = new Sndfile.File (file_name, Mode.WRITE, ref info);
        if (file == null) {
            print (@"Could not write audio $file_name: $(Sndfile.File.strerror(file))\n");
            return 0;
            }
            
        count_t result = file.writef_short ((short []) buffer, (Sndfile.count_t) (size / sizeof (int16) / info.channels));
        if (result != 0) {
            print ("Failed to save wav file %s, error: %s\n", file_name, Sndfile.File.strerror(file));
            return 1;
        }
        
        print ("Successfully exported %s\n", file_name);
        
        return 0;
    } 
}
