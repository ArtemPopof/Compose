using AlsaNew;

public class AlsaAudioInterfaceImpl : GLib.Object, AudioInterface {

    private PcmDevice device;
    private PcmHardwareParams *hardwareParams;
    private PcmSoftwareParams *softwareParams;
    private uint8 buf[4096];
    
    public int init () {
        stdout.printf ("Initializing alsa backend\n");
        
        stdout.printf ("Setting up default device hw:0,0\n");
        var errorCode = PcmDevice.open (out device, "hw:0,0", PcmStream.PLAYBACK);
        
        if (errorCode < 0) {
            var errorMessage = AlsaNew.strerror (errorCode);
            stdout.printf ("Initialization error: " + errorMessage);
            return 1;
        }
        
        stdout.printf ("Device opened, type=%d, name=%s\n", device.get_type (), device.get_name ());
        
        stdout.printf ("Getting device info\n");
                
        stdout.printf ("Malloc for hardwareParams\n");
        
        errorCode = PcmHardwareParams.malloc (out hardwareParams);
        if (errorCode < 0) {
            stdout.printf ("Failed to allocate hardware params structure\n");
            return 1;
        }
        
        stdout.printf ("Configure hardware params");
        
        if (!configure_playback_params ()) {
            return 1;
        }
        
        stdout.printf ("Configure software parameters\n");
        errorCode = PcmSoftwareParams.malloc (out softwareParams);
        if (errorCode < 0) {
            stdout.printf ("Can't malloc software parameters");
            return 1;
        }
        
        errorCode = device.sw_params_current (softwareParams);
        if (errorCode < 0) {
            stdout.printf ("Can't get software parameters");
            return 1;
        }
        
        errorCode = device.sw_params_set_avail_min (softwareParams, 4096);
        if (errorCode < 0) {
            stdout.printf ("Can't set min avail software parameter");
            return 1;
        }
        
        errorCode = device.sw_params_set_start_threshold (softwareParams, 0U);
        if (errorCode < 0) {
            stdout.printf ("Can't start threshold software parameter");
            return 1;
        }
        
        errorCode = device.sw_params (softwareParams);
        if (errorCode < 0) {
            stdout.printf ("Can't set software parameters");
            return 1;
        }
        
        stdout.printf ("Prepare device to be used\n");
        errorCode = device.prepare ();
        if (errorCode < 0) {
            stdout.printf ("Failed to prepare device");
            return 1;
        }
        
        stdout.printf ("Write data to device\n");
        
        PcmSignedFrames framesCount;
        for (int i = 0; i < 22; ++i) {
            framesCount = device.writei (buf, 128);
            if (framesCount != 128) {
                stdout.printf ("Failed to write to device:");
                //return 0;
            }
        }

        start_audio_thread ();
        
        return 0;
    }
    
    private bool configure_playback_params () {
        int errorCode;
        
        errorCode = device.hw_params_any (hardwareParams);
        if (errorCode < 0) {
            stdout.printf ("Failed to get device params\n");
            return false;
        }
        
        stdout.printf ("Configuring device for playback\n");
        errorCode = device.hw_params_set_access (hardwareParams, PcmAccess.RW_INTERLEAVED);
        if (errorCode < 0) {
            stdout.printf ("Failed to set interleaved access for the device\n");
            return false;
        }
        
        stdout.printf ("Set format to s16_le\n");
        errorCode = device.hw_params_set_format (hardwareParams, PcmFormat.S16_LE);
        if (errorCode < 0) {
            stdout.printf ("Failed to set format for the device\n");
            return false;
        }
        
        int rate = 44100;
        
        stdout.printf ("Set sample rate to 44.1kHz\n");
        errorCode = device.hw_params_set_rate_near (hardwareParams, ref rate, 0);
        if (errorCode < 0) {
            stdout.printf ("Failed to set sample rate");
            return false;
        }
        
        stdout.printf ("Set up 2 channels\n");
        errorCode = device.hw_params_set_channels (hardwareParams, 2);
        if (errorCode < 0) {
            stdout.printf ("Failed to set channels");
            return false;
        }
        
        errorCode = device.hw_params (hardwareParams);
        if (errorCode < 0) {
            stdout.printf ("Setting params failed");
            return false;
        }
        
        return true;
    }
    
    private void start_audio_thread () {
        Thread.create<int> (audio_func, false);
    }
    
    private int audio_func () {
        int errorCode;
        PcmSignedFrames framesToDeliver;

        while (true) {
            /* wait till the interface is ready for data, or 1 second
			   has elapsed.
			*/
			
			errorCode = device.wait (1000);
			if (errorCode < 0) {
			    stdout.printf ("audio thread error\n");
			    return 1;
			}
			
		    /* find out how much space is available for playback data */
		    framesToDeliver = device.avail_update ();
		    if (framesToDeliver < 0) {
		        if (framesToDeliver == -Posix.EPIPE) {
		            stdout.printf ("an xrun occured\n");
		            break;
		        } else {
		            stdout.printf ("Unknown alsa update count");
					break;
		        }
		    }
		    
		    framesToDeliver = framesToDeliver > 4096 ? 4096 : framesToDeliver;
		    
		    if (playback_callback (framesToDeliver) != framesToDeliver) {
		        stderr.printf ("playback callback failed\n");
		        break;
		    }
        }
        
        return 0;
    }
    
    private PcmSignedFrames playback_callback (PcmUnsignedFrames frameCount) {
        PcmSignedFrames framesWriten;
        
        stdout.printf ("playback called with frames\n");
        
        /* fill buff with data */
        framesWriten = device.writei (buf, frameCount);
        if (framesWriten < 0) {
            stderr.printf ("write failed");
        }
        
        return framesWriten;
    }
    
    public void play (AudioData clip, bool looped) {
        
    }
    
    public void stop (AudioData clip) {
        
    }
    
    public void record () {
        
    }
    
    public void close () {
        device.close ();
    }
    
    public AudioData stop_record () {
        return null;
    } 
    
    public uint get_sample_rate () { return 0; }
    
    public void set_transport (Transport transport) {}
}
