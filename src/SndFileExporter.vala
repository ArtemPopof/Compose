using Sndfile;

public class SndFileExporter : GLib.Object, Exporter {
    
    public int export_wav (float *buffer, size_t size, string file_name) {
        Info info = {};
        info.samplerate = 24000;
        info.channels = 2;
        info.format = Format.WAV | Format.FLOAT;
        
        Sndfile.File file = new Sndfile.File (file_name, Mode.WRITE, ref info);
        if (file == null) {
            print (@"Could not write audio $file_name: $(Sndfile.File.strerror(file))\n");
            return 0;
        }
        
        // var floatBuffer = (float* ) buffer;
        // for (int i = 0; i < 5000; i++) {
        //     print (": %f", floatBuffer[i]);
        // }
        //             
        count_t result = file.write_float ((float[])buffer, (Sndfile.count_t) (size / sizeof (float)));
        if (result < 0) {
            print ("Failed to save wav file %s, error: %s, result: %u\n", file_name, Sndfile.File.strerror(file), (uint) result);
            return 1;
        }
        
        print ("Successfully exported %s\n", file_name);
        
        return 0;
    } 
}
