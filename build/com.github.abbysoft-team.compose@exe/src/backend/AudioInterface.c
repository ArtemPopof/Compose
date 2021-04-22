/* AudioInterface.c generated by valac 0.40.25, the Vala compiler
 * generated from AudioInterface.vala, do not modify */



#include <glib.h>
#include <glib-object.h>


#define TYPE_AUDIO_INTERFACE (audio_interface_get_type ())
#define AUDIO_INTERFACE(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_AUDIO_INTERFACE, AudioInterface))
#define IS_AUDIO_INTERFACE(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_AUDIO_INTERFACE))
#define AUDIO_INTERFACE_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), TYPE_AUDIO_INTERFACE, AudioInterfaceIface))

typedef struct _AudioInterface AudioInterface;
typedef struct _AudioInterfaceIface AudioInterfaceIface;

#define TYPE_AUDIO_DATA (audio_data_get_type ())
#define AUDIO_DATA(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), TYPE_AUDIO_DATA, AudioData))
#define AUDIO_DATA_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), TYPE_AUDIO_DATA, AudioDataClass))
#define IS_AUDIO_DATA(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), TYPE_AUDIO_DATA))
#define IS_AUDIO_DATA_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), TYPE_AUDIO_DATA))
#define AUDIO_DATA_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), TYPE_AUDIO_DATA, AudioDataClass))

typedef struct _AudioData AudioData;
typedef struct _AudioDataClass AudioDataClass;

struct _AudioInterfaceIface {
	GTypeInterface parent_iface;
	gint (*init) (AudioInterface* self);
	void (*play) (AudioInterface* self, AudioData* clip, gboolean looped);
	void (*stop) (AudioInterface* self, AudioData* clip);
	void (*record) (AudioInterface* self);
	AudioData* (*stop_record) (AudioInterface* self);
	void (*close) (AudioInterface* self);
};



GType audio_data_get_type (void) G_GNUC_CONST;
GType audio_interface_get_type (void) G_GNUC_CONST;
gint audio_interface_init (AudioInterface* self);
void audio_interface_play (AudioInterface* self,
                           AudioData* clip,
                           gboolean looped);
void audio_interface_stop (AudioInterface* self,
                           AudioData* clip);
void audio_interface_record (AudioInterface* self);
AudioData* audio_interface_stop_record (AudioInterface* self);
void audio_interface_close (AudioInterface* self);


gint
audio_interface_init (AudioInterface* self)
{
#line 3 "/home/artem/Documents/ElementaryProjects/Compose/src/backend/AudioInterface.vala"
	g_return_val_if_fail (self != NULL, 0);
#line 3 "/home/artem/Documents/ElementaryProjects/Compose/src/backend/AudioInterface.vala"
	return AUDIO_INTERFACE_GET_INTERFACE (self)->init (self);
#line 61 "AudioInterface.c"
}


void
audio_interface_play (AudioInterface* self,
                      AudioData* clip,
                      gboolean looped)
{
#line 5 "/home/artem/Documents/ElementaryProjects/Compose/src/backend/AudioInterface.vala"
	g_return_if_fail (self != NULL);
#line 5 "/home/artem/Documents/ElementaryProjects/Compose/src/backend/AudioInterface.vala"
	AUDIO_INTERFACE_GET_INTERFACE (self)->play (self, clip, looped);
#line 74 "AudioInterface.c"
}


void
audio_interface_stop (AudioInterface* self,
                      AudioData* clip)
{
#line 6 "/home/artem/Documents/ElementaryProjects/Compose/src/backend/AudioInterface.vala"
	g_return_if_fail (self != NULL);
#line 6 "/home/artem/Documents/ElementaryProjects/Compose/src/backend/AudioInterface.vala"
	AUDIO_INTERFACE_GET_INTERFACE (self)->stop (self, clip);
#line 86 "AudioInterface.c"
}


void
audio_interface_record (AudioInterface* self)
{
#line 8 "/home/artem/Documents/ElementaryProjects/Compose/src/backend/AudioInterface.vala"
	g_return_if_fail (self != NULL);
#line 8 "/home/artem/Documents/ElementaryProjects/Compose/src/backend/AudioInterface.vala"
	AUDIO_INTERFACE_GET_INTERFACE (self)->record (self);
#line 97 "AudioInterface.c"
}


AudioData*
audio_interface_stop_record (AudioInterface* self)
{
#line 9 "/home/artem/Documents/ElementaryProjects/Compose/src/backend/AudioInterface.vala"
	g_return_val_if_fail (self != NULL, NULL);
#line 9 "/home/artem/Documents/ElementaryProjects/Compose/src/backend/AudioInterface.vala"
	return AUDIO_INTERFACE_GET_INTERFACE (self)->stop_record (self);
#line 108 "AudioInterface.c"
}


void
audio_interface_close (AudioInterface* self)
{
#line 11 "/home/artem/Documents/ElementaryProjects/Compose/src/backend/AudioInterface.vala"
	g_return_if_fail (self != NULL);
#line 11 "/home/artem/Documents/ElementaryProjects/Compose/src/backend/AudioInterface.vala"
	AUDIO_INTERFACE_GET_INTERFACE (self)->close (self);
#line 119 "AudioInterface.c"
}


static void
audio_interface_default_init (AudioInterfaceIface * iface)
{
}


GType
audio_interface_get_type (void)
{
	static volatile gsize audio_interface_type_id__volatile = 0;
	if (g_once_init_enter (&audio_interface_type_id__volatile)) {
		static const GTypeInfo g_define_type_info = { sizeof (AudioInterfaceIface), (GBaseInitFunc) NULL, (GBaseFinalizeFunc) NULL, (GClassInitFunc) audio_interface_default_init, (GClassFinalizeFunc) NULL, NULL, 0, 0, (GInstanceInitFunc) NULL, NULL };
		GType audio_interface_type_id;
		audio_interface_type_id = g_type_register_static (G_TYPE_INTERFACE, "AudioInterface", &g_define_type_info, 0);
		g_type_interface_add_prerequisite (audio_interface_type_id, G_TYPE_OBJECT);
		g_once_init_leave (&audio_interface_type_id__volatile, audio_interface_type_id);
	}
	return audio_interface_type_id__volatile;
}


