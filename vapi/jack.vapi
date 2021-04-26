/* Copyright (c) 2016 Joshua A. Cearley

   Permission is hereby granted, free of charge, to any person
   obtaining a copy of this software and associated documentation
   files (the "Software"), to deal in the Software without
   restriction, including without limitation the rights to use, copy,
   modify, merge, publish, distribute, sublicense, and/or sell copies
   of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be
   included in all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
   NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
   BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
   ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
   CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE.
*/

[CCode(cheader_filename="jack/jack.h", cprefix="jack_")]
namespace Jack {
	[CCode(cname="JACK_DEFAULT_AUDIO_TYPE")]
	const string DefaultAudioType;
	[CCode(cname="JACK_DEFAULT_MIDI_TYPE")]
	const string DefaultMidiType;

	[CCode(cname="jack_options_t", cprefix="Jack")]
	public enum Options {
		NullOption,
		NoStartServer,
		UseExactName,
		ServerName,
		LoadName,
		LoadInit,
		SessionID,
	}

	[CCode(cname="jack_status_t", cprefix="Jack")]
	[Flags]
	public enum Status {
		Failure,
		InvalidOption,
		NameNotUnique,
		ServerStarted,
		ServerFailed,
		ServerError,
		NoSuchClient,
		LoadFailure,
		InitFailure,
		ShmFailure,
		VersionError,
		BackendError,
		ClientZombie,
	}

	[CCode(cname="jack_latency_callback_mode_t", cprefix="Jack")]
	public enum LatencyCallbackMode {
		CaptureLatency,
		PlaybackLatency,
	}

	[CCode(cname="jack_latency_range_t")]
	public struct LatencyRange {
		NFrames min;
		NFrames max;
	}

	[SimpleType]
	[CCode(cname="jack_nframes_t")]
	public struct NFrames: uint32 {}

	[SimpleType]
	[CCode(cname="jack_time_t")]
	public struct Time: uint64 {}

	[SimpleType]
	[IntegerType(rank=7)]
	[CCode(cname="jack_port_id_t")]
	public struct PortId {}

	[SimpleType]
	[IntegerType(rank=11)]
	[CCode(cname="jack_uuid_t")]
	public struct Uuid {}

	[SimpleType]
	[IntegerType(rank=11)]
	[CCode(cname="jack_unique_t")]
	public struct Unique {}

	[CCode (cname="JackBufferSizeCallback")]
	public delegate int BufferSizeCallback (NFrames nframes);
	[CCode (cname="JackGraphOrderCallback")]
	public delegate int GraphOrderCallback ();
	[CCode (cname="JackProcessCallback")]
	public delegate int ProcessCallback (NFrames nframes);
	[CCode (cname="JackSampleRateCallback")]
	public delegate int SampleRateCallback (NFrames nframes);
	[CCode (cname="JackXRunCallback")]
	public delegate int XRunCallback ();
	[CCode (cname="JackClientRegistrationCallback")]
	public delegate void ClientRegistrationCallback (string name, int reg);
	[CCode (cname="JackFreewheelCallback")]
	public delegate void FreewheelCallback (int starting);
	[CCode (cname="JackInfoShutdownCallback")]
	public delegate void InfoShutdownCallback (Status code, string reason);
	[CCode (cname="JackLatencyCallback")]
	public delegate void LatencyCallback (LatencyCallbackMode mode);
	[CCode (cname="JackPortConnectCallback")]
	public delegate void PortConnectCallback (PortId a, PortId b, int connect);
	[CCode (cname="JackPortRegistrationCallback")]
	public delegate void PortRegistrationCallback (PortId port, int register);
	[CCode (cname="JackPortRenameCallback")]
	public delegate void PortRenameCallback (PortId port, string old_name, string new_name);
	[CCode (cname="JackShutdownCallback")]
	public delegate void ShutdownCallback ();
	[CCode (cname="JackThreadInitCallback")]
	public delegate void ThreadInitCallback ();
	[CCode (cname="JackThreadCallback")]
	public delegate void* ThreadCallback ();
	[CCode (cname="void* (*start_routine)(void*)")]
	public delegate void* ThreadStartRoutine();

	[CCode (cname="jack_transport_state_t", cprefix="JackTransport")]
	public enum TransportState {
		Stopped,
		Rolling,
		Looping,
		Starting,
	}

	[CCode(cname="jack_position_bits_t", cprefix="Jack")]
	public enum PositionBits {
		PositionBBT,
		PositionTimecode,
		BBTFrameOffset,
		AudioVideoRatio,
		VideoFrameOffset,
	}

	[Compact]
	[CCode (cname="jack_position_t")]
	public class Position {
		// read_only
		public Unique unique_1;
		public Time usecs;
		public NFrames frame_rate;
		// mandatory fields
		public NFrames frame;
		public PositionBits valid;
		// JackPositionBBT fields
		public int32 bar;
		public int32 beat;
		public int32 tick;
		public double bar_start_tick;
		public float beats_per_bar;
		public float beat_type;
		public double ticks_per_beat;
		public double beats_per_minute;
	}

	public delegate int SyncCallback (TransportState state, Position pos);
	public delegate void TimebaseCallback (TransportState state, NFrames nframes, Position pos, int new_pos);

	// TODO
	// [CCode (cname="jack_thread_creator_t")]
	// delegate int jack_thread_creator_t (NativeThread* thread, const pthread_attr_t* attr, void *(*function)(void *), void* arg)

	// XXX if there is a proper vala type for this, let me know
	[SimpleType]
	[IntegerType(rank=9)]
	[CCode(cname="pthread_t", cprefix="jack_")]
	public struct NativeThread {
		public int acquire_real_time_scheduling ();
		public int drop_real_time_scheduling ();
	}

	// TODO
	//void jack_set_thread_creator (jack_thread_creator_t creator);

	public delegate void InfoCallback(string message);
	[CCode(cname="jack_set_error_function")]
	public void set_error_function (InfoCallback func);
	[CCode(cname="jack_set_info_function")]
	public void set_info_function (InfoCallback func);

	[CCode(cname="JackSessionCallback")]
	public delegate void SessionCallback (SessionEvent* event, void* arg);

	[CCode(cname="JackSessionEventType", cprefix="JackSession")]
	public enum SessionEventType {
		Save = 1,
		SaveAndQuit = 2,
		SaveTemplate = 3
	}

	[CCode(cname="JackPropertyChangeCallback")]
	public delegate void PropertyChangeCallback (Uuid subject, string key, PropertyChange change, void* arg);

	[CCode(cname="jack_property_change_t", cprefix="Property")]
	public enum PropertyChange {
		Created,
		Changed,
		Deleted
	}

	[Flags]
	[CCode(cname="JackSessionFlags", cprefix="JackSession")]
	public enum SessionFlags {
		SaveError = 0x01,
		NeedTerminal = 0x02
	}

	[Flags]
	[CCode(cname="JackPortFlags", cprefix="JackPort")]
	public enum PortFlags {
		IsInput,
		IsOutput,
		IsPhysical,
		CanMonitor,
		IsTerminal,
	}

	[CCode(cname="jack_session_event_t", free_function="jack_session_event_free")]
	public struct SessionEvent {
		public SessionEventType type;
		public string session_dir;
		public string client_uuid;
		// XXX must be memory that can be freed by C
		public string command_line;
		public SessionFlags flags;
		public uint32 future;
	}

	[CCode(cprefix="jack_midi_", cheader_filename="jack/midiport.h")]
	namespace Midi {
		[SimpleType]
		[CCode(cname="jack_midi_data_t")]
		public struct Data: uchar {}

		[CCode(cname="jack_midi_event_t")]
		public struct Event {
			public NFrames time;
			public size_t size;
			public Data* buffer;
		}

		public NFrames get_event_count (void *port_buffer);
		public int event_get (Event* event, void* port_buffer, uint32 event_index);
		public void clear_buffer (void* port_buffer);
		public size_t max_event_size (void* port_buffer);
		public Data* event_reserve (void* port_buffer, NFrames time, size_t data_size);
		public int event_write (void* port_buffer, NFrames time, Data* data, size_t data_size);
		public uint32 get_lost_event_count (void* port_buffer);
	}

	[CCode(cname="jack_property_t")]
	public struct Property {
		public string key;
		public string data;
		public string type;
	}

	[CCode(cname="jack_description_t")]
	public struct Description {
		public Uuid subject;
		public uint32 property_cnt;
		public Property* properties;
		public uint32 property_size;
	}

	[CCode(cname="jack_get_property")]
	public int jack_get_property (Uuid subject, string key, string* value, string* type);
	[CCode(cname="jack_free_description")]
	public void jack_free_description (Description* desc, int free_description_itself);
	[CCode(cname="jack_get_all_properties")]
	public int jack_get_all_properties (Description** descs);
	[CCode(cname="jack_get_properties")]
	public int jack_get_properties (Uuid subject, Description* desc);

	[Compact]
	[CCode(cname="jack_client_t", free_function="jack_client_close")]
	public class Client {
		[CCode(cname="jack_client_open")]
		public static Client open(string name, Options options, out Status status_out);
		[CCode(cname="jack_client_name_size")]
		public static int name_size ();
		[CCode(cname="jack_get_client_name")]
		public string get_name ();
		[CCode(cname="jack_get_uuid_for_client_name")]
		string get_uuid_for_name (string name);
		[CCode(cname="jack_get_client_name_by_uuid")]
		string get_name_by_uuid (string uuid);
		[CCode(cname="jack_internal_client_new")]
		public int internal_new (string client_name, string load_name, string load_init);
		[CCode(cname="jack_internal_client_close")]
		public void internal_close (string client_name);
		[CCode(cname="jack_activate")]
		public int activate ();
		[CCode(cname="jack_deactivate")]
		public int deactivate ();

		public bool active {
			set {
				if (value) {
					this.activate ();
				} else {
					this.deactivate ();
				}
			}
		}

		// XXX I don't know the proper way to bind this; it's a standard pthread, though, but what is that called in vala?
		[CCode(cname="jack_client_thread_id")]
		public NativeThread thread_id ();
		[CCode(cname="jack_client_real_time_priority")]
		public int real_time_priority ();
		[CCode(cname="jack_client_max_real_time_priority")]
		public int max_real_time_priority ();
		[CCode(cname="jack_client_create_thread")]
		public int create_thread (out NativeThread thread, int priority, int realtime, ThreadStartRoutine start_routine, void* arg);
		[CCode(cname="jack_set_freewheel")]
		public int set_freewheel (int onoff);
		[CCode(cname="jack_set_buffer_size")]
		public int set_buffer_size (NFrames nframes);
		[CCode(cname="jack_get_sample_rate")]
		public NFrames get_sample_rate ();
		[CCode(cname="jack_get_buffer_size")]
		public NFrames get_buffer_size ();
		[CCode(cname="jack_engine_takeover_timebase")]
		public int engine_takeover_timebase ();
		[CCode(cname="jack_cpu_load")]
		public float cpu_load ();
		[CCode(cname="jack_port_register")]
		public Port? port_register (string port_name, string port_type, PortFlags flags, ulong buffer_size);
		[CCode(cname="jack_port_unregister")]
		public int port_unregister (Port port);
		[CCode(cname="jack_port_is_mine")]
		public int is_mine (Port port);
		[CCode(cname="jack_port_get_all_connections")]
		public string* get_all_connections (Client client, Port port);
		[CCode(cname="jack_port_request_monitor_by_name")]
		public int port_request_monitor_by_name (string port_name, int onoff);
		[CCode(cname="jack_connect")]
		public int connect (string source_port, string destination_port);
		[CCode(cname="jack_disconnect")]
		public int disconnect (string source_port, string destination_port);
		[CCode(cname="jack_port_disconnect")]
		public int port_disconnect (Port port);
		[CCode(cname="jack_port_type_get_buffer_size")]
		public size_t port_type_get_buffer_size (string port_type);
		[CCode(cname="jack_get_ports")]
		public string* get_ports (string port_name_pattern, string type_name_pattern, ulong flags);
		[CCode(cname="jack_port_by_name")]
		public Port port_by_name (string port_name);
		[CCode(cname="jack_port_by_id")]
		public Port port_by_id (PortId port_id);
		[CCode(cname="jack_recompute_total_latencies")]
		public int recompute_total_latencies ();
		[CCode(cname="jack_frames_since_cycle_start")]
		public NFrames frames_since_cycle_start ();
		[CCode(cname="jack_frame_time")]
		public NFrames frame_time ();
		[CCode(cname="jack_last_frame_time")]
		public NFrames last_frame_time ();
		[CCode(cname="jack_get_cycle_times")]
		public int get_cycle_times (out NFrames current_frames, out Time current_usecs, out Time next_usecs, out float period_usecs);
		[CCode(cname="jack_frames_to_time")]
		public Time frames_to_time (NFrames frames);
		[CCode(cname="jack_time_to_frames")]
		public NFrames time_to_frames (Time time);
		[CCode(cname="jack_get_time")]
		public Time get_time ();
		[CCode(cname="jack_release_timebase")]
		public int release_timebase ();
		[CCode(cname="jack_set_sync_callback")]
		public int set_sync_callback (SyncCallback sync_callback, void *arg);
		[CCode(cname="jack_set_sync_timeout")]
		public int set_sync_timeout (Time timeout);
		[CCode(cname="jack_set_timebase_callback")]
		public int set_timebase_callback (int conditional, TimebaseCallback timebase_callback, void* arg);
		[CCode(cname="jack_transport_locate")]
		public int transport_locate (NFrames frame);
		[CCode(cname="jack_transport_query")]
		public TransportState transport_query (Position pos);
		[CCode(cname="jack_get_current_transport_frame")]
		public NFrames get_current_transport_frame ();
		[CCode(cname="jack_transport_reposition")]
		public int transport_reposition (Position pos);
		[CCode(cname="jack_transport_start")]
		public void transport_start ();
		[CCode(cname="jack_transport_stop")]
		public void transport_stop ();
		[CCode(cname="jack_cycle_wait")]
		public NFrames cycle_wait ();
		[CCode(cname="jack_cycle_signal")]
		public void cycle_signal (int status);
		[CCode(cname="jack_set_process_thread")]
		public int set_process_thread (ThreadCallback fun, void* arg);

		[CCode(cname="jack_set_session_callback")]
		public int set_session_callback (SessionCallback session_callback, void* arg);
		[CCode(cname="jack_session_reply")]
		public int session_reply (SessionEvent* event);
		[CCode(cname="jack_client_get_uuid")]
		public string client_get_uuid ();
		[CCode(cname="jack_set_property")]
		public int set_property (Uuid subject, string key, string value, string type);
		[CCode(cname="jack_remove_property")]
		public int remove_property (Uuid subject, string key);
		[CCode(cname="jack_remove_properties")]
		public int remove_properties (Uuid subject);
		[CCode(cname="jack_remove_all_properties")]
		public int remove_all_properties ();
		[CCode(cname="jack_set_property_change_callback")]
		public int set_property_change_callback (PropertyChangeCallback callback, void* arg);

		[CCode(cname="jack_set_thread_init_callback")]
		public int set_thread_init_callback (ThreadInitCallback thread_init_callback);
		[CCode(cname="jack_on_shutdown")]
		public void on_shutdown (ShutdownCallback function);
		[CCode(cname="jack_on_info_shutdown")]
		public void on_info_shutdown (InfoShutdownCallback function);
		[CCode(cname="jack_set_process_callback")]
		public int set_process_callback (ProcessCallback process_callback);
		[CCode(cname="jack_set_freewheel_callback")]
		public int set_freewheel_callback (FreewheelCallback freewheel_callback);
		[CCode(cname="jack_set_buffer_size_callback")]
		public int set_buffer_size_callback (BufferSizeCallback bufsize_callback);
		[CCode(cname="jack_set_sample_rate_callback")]
		public int set_sample_rate_callback (SampleRateCallback srate_callback);
		[CCode(cname="jack_set_client_registration_callback")]
		public int set_client_registration_callback (ClientRegistrationCallback registration_callback);
		[CCode(cname="jack_set_port_registration_callback")]
		public int set_port_registration_callback (PortRegistrationCallback registration_callback);
		[CCode(cname="jack_set_port_rename_callback")]
		public int set_port_rename_callback (PortRenameCallback rename_callback);
		[CCode(cname="jack_set_port_connect_callback")]
		public int set_port_connect_callback (PortConnectCallback connect_callback);
		[CCode(cname="jack_set_graph_order_callback")]
		public int set_graph_order_callback (GraphOrderCallback graph_callback);
		[CCode(cname="jack_set_xrun_callback")]
		public int set_xrun_callback (XRunCallback xrun_callback);
		[CCode(cname="jack_set_latency_callback")]
		public int set_latency_callback (LatencyCallback latency_callback);
	}

	[Compact]
	[CCode(cname="jack_port_t", free_function="", cprefix="jack_port_")]
	public class Port {
		public void* get_buffer (NFrames size);
		public string name ();
		public Uuid uuid ();
		public string short_name ();
		public int flags ();
		public string type ();
		public int connected ();
		public int connected_to (string port_name);
		public string* get_connections ();
		public int set_name (string port_name);
		public int set_alias (string alias);
		public int unset_alias (string alias);
		//TODO
		//public int get_aliases (char *const aliases[2]);
		public int request_monitor (int onoff);
		public int ensure_monitor (int onoff);
		public int monitoring_input ();
		public int jack_port_name_size ();
		public int jack_port_type_size ();
		public void get_latency_range (LatencyCallbackMode mode, LatencyRange* range);
		public void set_latency_range (LatencyCallbackMode mode, LatencyRange* range);
	}

	[CCode(cprefix="jackctl_")]
	namespace Ctl {
		public Posix.sigset_t setup_signals (uint flags);
		public void wait_signals (Posix.sigset_t signals);

		public delegate bool OnDeviceAcquire (string device_name);
		public delegate void OnDeviceReleased (string device_name);

		[Compact]
		[CCode(cname="jackctl_server_t", cprefix="jackctl_server_", has_destroy_function=true, destroy_function="jackctl_server_destroy")]
		public class Server {
			public static Server jackctl_server_create (OnDeviceAcquire on_device_acquire, OnDeviceReleased on_device_released);
			//public void destroy ();
			public bool start (Driver driver);
			public bool stop ();
			//TODO
			//public const JSList * get_drivers_list ();
			//TODO
			//public const JSList * get_parameters ();
			//TODO
			//public const JSList * get_internals_list ();
			public bool load_internal (Internal internal);
			public bool unload_internal (Internal internal);
			public bool add_slave (Driver driver);
			public bool remove_slave (Driver driver);
			public bool switch_master (Driver driver);
		}

		[Compact]
		[CCode(cname="jackctl_driver_t", cprefix="jackctl_driver_")]
		public class Driver {
			public string get_name ();
			//TODO
			//public JSList* get_parameters ();
		}

		[CCode(cname="jackctl_internal_t", cprefix="jackctl_internal_")]
		public class Internal {
			public string get_name ();
			//TODO
			//public JSList *get_parameters ();
		}

		[CCode(cname="jackctl_param_type_t", cprefix="JackParam")]
		public enum ParamType {
			Int,
			UInt,
			Char,
			String,
		}

		[SimpleType]
		[CCode(cname="jackctl_parameter_value")]
		public struct ParamValue {
			[CCode(cname="data.ui")]
			public uint32 ui;
			[CCode(cname="data.i")]
			public int32 i;
			[CCode(cname="data.c")]
			public char c;
			[CCode(cname="data.str")]
			public char str [128];
			[CCode(cname="data.b")]
			public bool b;
		}

		[Compact]
		[CCode(cname="jackctl_parameter_t", cprefix="jackctl_parameter_")]
		public class Parameter {
			public string get_name ();
			public string get_short_description ();
			public string get_long_description ();
			public ParamType get_type ();
			public char get_id ();
			public bool is_set ();
			public bool reset ();
			public ParamValue get_value ();
			public bool set_value (ParamValue* value_ptr);
			public ParamValue get_default_value ();
			public bool has_range_constraint ();
			public bool has_enum_constraint ();
			public uint32 get_enum_constraints_count ();
			public ParamValue get_enum_constraint_value (uint32 index);
			public string get_enum_constraint_description (uint32 index);
			public void get_range_constraint (ParamValue* min_ptr, ParamValue* max_ptr);
			public bool constraint_is_strict ();
			public bool constraint_is_fake_value ();
		}

		//TODO
		//void jack_error (const char *format,...)
		//TODO
		//void jack_info (const char *format,...)
		//TODO
		//void jack_log (const char *format,...)
	}
}
